CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE clubs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    country VARCHAR(100) NOT NULL,
    founded_year INT,
    stadium_name VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE players (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    birth_date DATE,
    nationality VARCHAR(100),
    position VARCHAR(50),
    height_cm INT,
    current_club_id UUID REFERENCES clubs(id) ON DELETE SET NULL,
    current_market_value_eur BIGINT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE transfers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    from_club_id UUID REFERENCES clubs(id) ON DELETE SET NULL,
    to_club_id UUID REFERENCES clubs(id) ON DELETE SET NULL,
    transfer_date DATE NOT NULL,
    fee_eur BIGINT,
    season VARCHAR(10) NOT NULL,
    transfer_type VARCHAR(50) DEFAULT 'Permanent',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_players_club ON players(current_club_id);
CREATE INDEX idx_transfers_player ON transfers(player_id);
CREATE INDEX idx_transfers_date ON transfers(transfer_date DESC);
