USE sispark;

-- Data yang ada merupakan data sementara ( dummy ) untuk keperluan tugas worksheet P21

INSERT INTO pengendara
(id_pengendara, nama, email, password, no_hp)
VALUES
(1, 'Andi Pratama', 'andi@example.com', 'hash_password_andi', '081234567801'),
(2, 'Budi Santoso', 'budi@example.com', 'hash_password_budi', '081234567802'),
(3, 'Citra Lestari', 'citra@example.com', 'hash_password_citra', '081234567803'),
(4, 'Dewi Anggraini', 'dewi@example.com', 'hash_password_dewi', '081234567804'),
(5, 'Eko Saputra', 'eko@example.com', 'hash_password_eko', '081234567805');

INSERT INTO lokasi_parkir
(id_lokasi, nama_lokasi, alamat)
VALUES
(1, 'Parkir Kampus Utama', 'Jl. Pendidikan No. 1'),
(2, 'Parkir Gedung Perpustakaan', 'Jl. Pendidikan No. 2'),
(3, 'Parkir Pusat Perbelanjaan', 'Jl. Malioboro No. 10'),
(4, 'Parkir Rumah Sakit', 'Jl. Kesehatan No. 5'),
(5, 'Parkir GOR Kota', 'Jl. Olahraga No. 8');

INSERT INTO area_parkir
(id_area, id_lokasi, lantai)
VALUES
(1, 1, 'Lantai 1'),
(2, 1, 'Lantai 2'),
(3, 2, 'Basement'),
(4, 3, 'Lantai 1'),
(5, 4, 'Basement'),
(6, 5, 'Area Terbuka');

INSERT INTO slot_parkir
(id_slot, id_area, kode_slot, jenis_slot, status_slot)
VALUES
(1, 1, 'A-01', 'Reguler', 'Tersedia'),
(2, 1, 'A-02', 'VIP', 'Terisi'),
(3, 2, 'B-01', 'Reguler', 'Tersedia'),
(4, 2, 'B-02', 'VIP', 'Tersedia'),
(5, 3, 'C-01', 'Reguler', 'Terisi'),
(6, 3, 'C-02', 'VIP', 'Tersedia'),
(7, 4, 'D-01', 'Reguler', 'Tersedia'),
(8, 4, 'D-02', 'VIP', 'Terisi'),
(9, 5, 'E-01', 'Reguler', 'Tersedia'),
(10, 6, 'F-01', 'Reguler', 'Tersedia');

INSERT INTO tarif_parkir
(id_tarif, id_lokasi, jenis_slot, tarif_per_jam)
VALUES
(1, 1, 'Reguler', 3000.00),
(2, 1, 'VIP', 5000.00),
(3, 2, 'Reguler', 3000.00),
(4, 2, 'VIP', 5000.00),
(5, 3, 'Reguler', 5000.00),
(6, 3, 'VIP', 8000.00),
(7, 4, 'Reguler', 4000.00),
(8, 4, 'VIP', 7000.00),
(9, 5, 'Reguler', 3000.00),
(10, 5, 'VIP', 5000.00);

INSERT INTO sensor_iot
(id_sensor, id_slot, status_sensor)
VALUES
(1, 1, 'Aktif'),
(2, 2, 'Aktif'),
(3, 3, 'Aktif'),
(4, 4, 'Aktif'),
(5, 5, 'Aktif'),
(6, 6, 'Aktif'),
(7, 7, 'Aktif'),
(8, 8, 'Aktif'),
(9, 9, 'Aktif'),
(10, 10, 'Nonaktif');

INSERT INTO reservasi
(id_reservasi, id_pengendara, id_slot, nomor_plat, jenis_kendaraan,
 waktu_pemesanan, waktu_mulai, waktu_selesai, waktu_masuk, waktu_keluar,
 status_reservasi)
VALUES
(1, 1, 1, 'AB 1234 CD', 'Mobil',
 '2026-11-20 07:30:00', '2026-11-20 08:00:00', '2026-11-20 10:00:00',
 '2026-11-20 08:05:00', '2026-11-20 09:50:00', 'Selesai'),
(2, 2, 2, 'AB 2345 DE', 'Mobil',
 '2026-11-27 07:30:00', '2026-11-27 08:00:00', '2026-11-27 11:00:00',
 '2026-11-27 08:05:00', NULL, 'Berlangsung'),
(3, 3, 3, 'AB 3456 EF', 'Mobil',
 '2026-11-28 08:00:00', '2026-11-28 09:00:00', '2026-11-28 11:00:00',
 NULL, NULL, 'Menunggu Pembayaran'),
(4, 1, 4, 'AB 1234 CD', 'Mobil',
 '2026-11-25 12:30:00', '2026-11-25 13:00:00', '2026-11-25 15:00:00',
 '2026-11-25 13:05:00', '2026-11-25 14:45:00', 'Selesai'),
(5, 4, 5, 'AB 4567 FG', 'Mobil',
 '2026-11-28 08:30:00', '2026-11-28 09:00:00', '2026-11-28 12:00:00',
 NULL, NULL, 'Menunggu Pembayaran'),
(6, 5, 7, 'AB 5678 GH', 'Mobil',
 '2026-11-26 08:30:00', '2026-11-26 09:00:00', '2026-11-26 11:00:00',
 '2026-11-26 09:05:00', '2026-11-26 10:50:00', 'Selesai'),
(7, 2, 8, 'AB 2345 DE', 'Mobil',
 '2026-11-28 09:00:00', '2026-11-28 10:00:00', '2026-11-28 12:00:00',
 NULL, NULL, 'Menunggu Pembayaran');

 INSERT INTO pembayaran
(id_pembayaran, id_reservasi, id_tarif, tarif_parkir,
 metode_pembayaran, status_pembayaran, tanggal_pembayaran, batas_pembayaran)
VALUES
(1, 1, 1, 6000.00, 'QRIS', 'Berhasil',
 '2026-11-20 07:40:00', '2026-11-20 07:55:00'),
(2, 2, 2, 15000.00, 'Virtual Account', 'Berhasil',
 '2026-11-27 07:40:00', '2026-11-27 07:55:00'),
(3, 4, 2, 10000.00, 'QRIS', 'Berhasil',
 '2026-11-25 12:40:00', '2026-11-25 12:55:00'),
(4, 6, 5, 10000.00, 'Kartu Debit', 'Berhasil',
 '2026-11-26 08:40:00', '2026-11-26 08:55:00'),
(5, 7, 6, 16000.00, 'QRIS', 'Gagal',
 '2026-11-28 09:15:00', '2026-11-28 09:30:00');