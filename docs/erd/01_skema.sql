CREATE DATABASE IF NOT EXISTS sispark;
USE sispark;

CREATE TABLE Pengendara (
    id_pengendara INT AUTO_INCREMENT,
    nama VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    no_hp VARCHAR(20),

    CONSTRAINT pk_pengendara
        PRIMARY KEY (id_pengendara),

    CONSTRAINT uq_pengendara_email
        UNIQUE (email)
) ENGINE=InnoDB;

CREATE TABLE Lokasi_Parkir (
    id_lokasi INT AUTO_INCREMENT,
    nama_lokasi VARCHAR(100) NOT NULL,
    alamat TEXT NOT NULL,

    CONSTRAINT pk_lokasi_parkir
        PRIMARY KEY (id_lokasi)
) ENGINE=InnoDB;

CREATE TABLE Area_Parkir (
    id_area INT AUTO_INCREMENT,
    id_lokasi INT NOT NULL,
    lantai VARCHAR(20) NOT NULL,

    CONSTRAINT pk_area_parkir
        PRIMARY KEY (id_area),

    CONSTRAINT fk_area_lokasi
        FOREIGN KEY (id_lokasi)
        REFERENCES Lokasi_Parkir(id_lokasi)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE Slot_Parkir (
    id_slot INT AUTO_INCREMENT,
    id_area INT NOT NULL,
    kode_slot VARCHAR(20) NOT NULL,
    jenis_slot VARCHAR(20) NOT NULL,
    status_slot VARCHAR(30) NOT NULL,

    CONSTRAINT pk_slot_parkir
        PRIMARY KEY (id_slot),

    CONSTRAINT fk_slot_area
        FOREIGN KEY (id_area)
        REFERENCES Area_Parkir(id_area)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT uq_slot_area_kode
        UNIQUE (id_area, kode_slot),

    CONSTRAINT chk_jenis_slot
        CHECK (jenis_slot IN ('Reguler', 'VIP'))
) ENGINE=InnoDB;

CREATE TABLE Tarif_Parkir (
    id_tarif INT AUTO_INCREMENT,
    id_lokasi INT NOT NULL,
    jenis_slot VARCHAR(20) NOT NULL,
    tarif_per_jam DECIMAL(12,2) NOT NULL,

    CONSTRAINT pk_tarif_parkir
        PRIMARY KEY (id_tarif),

    CONSTRAINT fk_tarif_lokasi
        FOREIGN KEY (id_lokasi)
        REFERENCES Lokasi_Parkir(id_lokasi)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT uq_tarif_lokasi_jenis
        UNIQUE (id_lokasi, jenis_slot),

    CONSTRAINT chk_tarif_jenis_slot
        CHECK (jenis_slot IN ('Reguler', 'VIP')),

    CONSTRAINT chk_tarif_nominal
        CHECK (tarif_per_jam > 0)
) ENGINE=InnoDB;

CREATE TABLE Reservasi (
    id_reservasi INT AUTO_INCREMENT,
    id_pengendara INT NOT NULL,
    id_slot INT NOT NULL,
    nomor_plat VARCHAR(20) NOT NULL,
    jenis_kendaraan VARCHAR(30) NOT NULL,
    waktu_pemesanan DATETIME NOT NULL,
    waktu_mulai DATETIME,
    waktu_selesai DATETIME,
    waktu_masuk DATETIME,
    waktu_keluar DATETIME,
    status_reservasi VARCHAR(30) NOT NULL,

    CONSTRAINT pk_reservasi
        PRIMARY KEY (id_reservasi),

    CONSTRAINT fk_reservasi_pengendara
        FOREIGN KEY (id_pengendara)
        REFERENCES Pengendara(id_pengendara)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_reservasi_slot
        FOREIGN KEY (id_slot)
        REFERENCES Slot_Parkir(id_slot)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_waktu_parkir
        CHECK (
            waktu_keluar IS NULL
            OR waktu_masuk IS NULL
            OR waktu_keluar >= waktu_masuk
        )
) ENGINE=InnoDB;

CREATE TABLE Pembayaran (
    id_pembayaran INT AUTO_INCREMENT,
    id_reservasi INT NOT NULL,
    id_tarif INT NOT NULL,
    tarif_parkir DECIMAL(12,2) NOT NULL,
    metode_pembayaran VARCHAR(30) NOT NULL,
    status_pembayaran VARCHAR(30) NOT NULL,
    tanggal_pembayaran DATETIME,
    batas_pembayaran DATETIME NOT NULL,

    CONSTRAINT pk_pembayaran
        PRIMARY KEY (id_pembayaran),

    CONSTRAINT fk_pembayaran_reservasi
        FOREIGN KEY (id_reservasi)
        REFERENCES Reservasi(id_reservasi)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_pembayaran_tarif
        FOREIGN KEY (id_tarif)
        REFERENCES Tarif_Parkir(id_tarif)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT uq_pembayaran_reservasi
        UNIQUE (id_reservasi),

    CONSTRAINT chk_pembayaran_nominal
        CHECK (tarif_parkir >= 0)
) ENGINE=InnoDB;

CREATE TABLE Sensor_IoT (
    id_sensor INT AUTO_INCREMENT,
    id_slot INT NOT NULL,
    status_sensor VARCHAR(30) NOT NULL,

    CONSTRAINT pk_sensor_iot
        PRIMARY KEY (id_sensor),

    CONSTRAINT fk_sensor_slot
        FOREIGN KEY (id_slot)
        REFERENCES Slot_Parkir(id_slot)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT uq_sensor_slot
        UNIQUE (id_slot)
) ENGINE=InnoDB;

