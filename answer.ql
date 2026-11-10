-- =====================================================================
-- Database Assignment: Gaming Lounge & Esports Arena Management System
-- Database Name: gaming_lounge_db
-- =====================================================================

-- 1. Create and Use the Database
DROP DATABASE IF EXISTS gaming_lounge_db;
CREATE DATABASE gaming_lounge_db;
USE gaming_lounge_db;

-- =====================================================================
-- 2. Table Creation
-- =====================================================================

-- Members (Customers / Gamers)
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    balance DECIMAL(10, 2) DEFAULT 0.00,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Gaming Stations (PCs, Consoles, VR Rigs)
CREATE TABLE stations (
    station_id INT AUTO_INCREMENT PRIMARY KEY,
    station_name VARCHAR(50) NOT NULL,
    station_type ENUM('PC', 'Console', 'VR') NOT NULL,
    hourly_rate DECIMAL(6, 2) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- Gaming Sessions (Tracking usage and billing)
CREATE TABLE sessions (
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    station_id INT NOT NULL,
    start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    end_time TIMESTAMP NULL,
    total_cost DECIMAL(8, 2) NULL,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (station_id) REFERENCES stations(station_id) ON DELETE CASCADE
);

-- Tournaments Hosted at the Arena
CREATE TABLE tournaments (
    tournament_id INT AUTO_INCREMENT PRIMARY KEY,
    tournament_name VARCHAR(100) NOT NULL,
    game_title VARCHAR(100) NOT NULL,
    prize_pool DECIMAL(10, 2) NOT NULL,
    start_date DATE NOT NULL
);

-- Tournament Registrations (Many-to-Many relationship between Members and Tournaments)
CREATE TABLE tournament_registrations (
    registration_id INT AUTO_INCREMENT PRIMARY KEY,
    tournament_id INT NOT NULL,
    member_id INT NOT NULL,
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tournament_id) REFERENCES tournaments(tournament_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    UNIQUE KEY unique_entry (tournament_id, member_id)
);

-- =====================================================================
-- 3. Sample Data Insertion
-- =====================================================================

-- Insert Members
INSERT INTO members (first_name, last_name, email, phone_number, balance) VALUES
('Ayiik', 'Mayen', 'ayiik.mayen@example.com', '+254712345678', 1500.00),
('Sarah', 'Jenkins', 'sarah.j@example.com', '+254723456789', 850.50),
('Kevin', 'Ochieng', 'kevin.o@example.com', '+254734567890', 2500.00),
('Aisha', 'Mohamed', 'aisha.m@example.com', '+254745678901', 400.00);

-- Insert Stations
INSERT INTO stations (station_name, station_type, hourly_rate) VALUES
('PC-Alpha-01', 'PC', 300.00),
('PC-Alpha-02', 'PC', 300.00),
('PS5-Station-01', 'Console', 250.00),
('Xbox-Series-X-01', 'Console', 250.00),
('VR-Immersive-01', 'VR', 500.00);

-- Insert Active/Past Gaming Sessions
INSERT INTO sessions (member_id, station_id, start_time, end_time, total_cost) VALUES
(1, 1, '2026-11-10 14:00:00', '2026-11-10 17:00:00', 900.00),
(2, 3, '2026-11-10 15:30:00', '2026-11-10 17:30:00', 500.00),
(3, 5, '2026-11-10 16:00:00', NULL, NULL); -- Currently ongoing session

-- Insert Tournaments
INSERT INTO tournaments (tournament_name, game_title, prize_pool, start_date) VALUES
('EA Sports FC Showdown', 'eFootball / FC 26', 25000.00, '2026-11-20'),
('Apex Legends Trios Cup', 'Apex Legends', 50000.00, '2026-11-25');

-- Register Members for Tournaments
INSERT INTO tournament_registrations (tournament_id, member_id) VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 3),
(2, 4);

-- =====================================================================
-- 4. Sample Useful Queries
-- =====================================================================

-- View all members with positive wallet balances
-- SELECT * FROM members WHERE balance > 0;

-- View ongoing gaming sessions with member names and station details
-- SELECT s.session_id, CONCAT(m.first_name, ' ', m.last_name) AS gamer, st.station_name, s.start_time 
-- FROM sessions s
-- JOIN members m ON s.member_id = m.member_id
-- JOIN stations st ON s.station_id = st.station_id
-- WHERE s.end_time IS NULL;
