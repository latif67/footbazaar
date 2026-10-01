import psycopg2

# Verbindungsdaten zu deiner lokalen Docker-Datenbank
DB_CONFIG = {
    "dbname": "footbazaar",
    "user": "footbazaar_admin",
    "password": "secretpassword",
    "host": "localhost",
    "port": "5432"
}

def test_db_insert():
    try:
        # 1. Verbindung aufbauen
        conn = psycopg2.connect(**DB_CONFIG)
        cursor = conn.cursor()
        print("Erfolgreich mit der Datenbank verbunden.")

        # 2. Test-Verein einfügen und die generierte UUID zurückgeben lassen
        cursor.execute("""
            INSERT INTO clubs (name, country, founded_year, stadium_name)
            VALUES ('Fortuna Düsseldorf', 'Germany', 1895, 'Merkur Spiel-Arena')
            RETURNING id;
        """)
        club_id = cursor.fetchone()[0]
        print(f"Verein angelegt mit ID: {club_id}")

        # 3. Test-Spieler für diesen Verein anlegen
        cursor.execute("""
            INSERT INTO players (first_name, last_name, position, current_club_id, current_market_value_eur)
            VALUES ('Ao', 'Tanaka', 'Zentrales Mittelfeld', %s, 3500000)
            RETURNING id;
        """, (club_id,))
        player_id = cursor.fetchone()[0]
        print(f"Spieler angelegt mit ID: {player_id}")

        # 4. Transaktion bestätigen (Speichern in der DB)
        conn.commit()
        print("Daten erfolgreich in die Datenbank geschrieben!")

    except Exception as e:
        print(f"Ein Fehler ist aufgetreten: {e}")
    finally:
        # Verbindung sauber schließen
        if 'conn' in locals():
            cursor.close()
            conn.close()

if __name__ == "__main__":
    test_db_insert()


