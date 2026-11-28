USE sispark;

-- 1. Pertanyaan Bisnis:
-- Slot parkir apa saja yang tersedia pada suatu lokasi
-- dan area parkir tertentu?
-- Halaman/Fitur: Pencarian lokasi dan ketersediaan slot parkir
-- Teknik: JOIN
-- Total Baris : 7 Baris

SELECT
    lp.nama_lokasi,
    ap.lantai,
    sp.kode_slot,
    sp.jenis_slot,
    sp.status_slot
FROM lokasi_parkir AS lp
JOIN area_parkir AS ap
    ON lp.id_lokasi = ap.id_lokasi
JOIN slot_parkir AS sp
    ON ap.id_area = sp.id_area
WHERE sp.status_slot = 'Tersedia'
ORDER BY lp.nama_lokasi, ap.lantai, sp.kode_slot;

-- 2. Pertanyaan Bisnis:
-- Reservasi mana saja yang belum memiliki data pembayaran?
-- Halaman/Fitur: Halaman pembayaran dan status pembayaran reservasi
-- Teknik: LEFT JOIN dengan IS NULL
-- Total Baris : 2 Baris

SELECT
    r.id_reservasi,
    p.nama AS nama_pengendara,
    r.nomor_plat,
    r.waktu_pemesanan,
    r.status_reservasi
FROM reservasi AS r
JOIN pengendara AS p
    ON r.id_pengendara = p.id_pengendara
LEFT JOIN pembayaran AS pb
    ON r.id_reservasi = pb.id_reservasi
WHERE pb.id_pembayaran IS NULL
ORDER BY r.waktu_pemesanan DESC;

-- 3. Pertanyaan Bisnis:
-- Lokasi parkir mana saja yang masih memiliki minimal
-- sejumlah slot tersedia?
-- Halaman/Fitur: Pencarian lokasi dan ketersediaan parkir
-- Teknik: JOIN, GROUP BY, HAVING
-- Total Baris : 3 Baris
SELECT
    lp.id_lokasi,
    lp.nama_lokasi,
    COUNT(sp.id_slot) AS jumlah_slot_tersedia
FROM lokasi_parkir AS lp
JOIN area_parkir AS ap
    ON lp.id_lokasi = ap.id_lokasi
JOIN slot_parkir AS sp
    ON ap.id_area = sp.id_area
WHERE sp.status_slot = 'Tersedia'
GROUP BY lp.id_lokasi, lp.nama_lokasi
HAVING COUNT(sp.id_slot) >= 3 -- Misal yang dicari minimal 3 slot parkir
ORDER BY jumlah_slot_tersedia DESC;

-- 4. Pertanyaan Bisnis:
-- Berapa tarif parkir yang berlaku untuk suatu slot
-- berdasarkan lokasi dan jenis slot parkir?
-- Halaman/Fitur: Detail slot yang terdapat tarif parkir
-- Teknik: JOIN
-- Total Baris : 10 baris

SELECT
    lp.nama_lokasi,
    ap.lantai,
    sp.kode_slot,
    sp.jenis_slot,
    tp.tarif_per_jam
FROM slot_parkir AS sp
JOIN area_parkir AS ap
    ON sp.id_area = ap.id_area
JOIN lokasi_parkir AS lp
    ON ap.id_lokasi = lp.id_lokasi
JOIN tarif_parkir AS tp
    ON lp.id_lokasi = tp.id_lokasi
   AND sp.jenis_slot = tp.jenis_slot
ORDER BY lp.nama_lokasi, sp.jenis_slot, sp.kode_slot;

-- 5. Pertanyaan Bisnis:
-- Bagaimana rincian pembayaran suatu reservasi,
-- termasuk tarif, metode, dan status pembayarannya?
-- Halaman/Fitur: Detail pembayaran
-- Teknik: JOIN
-- Total Baris : 5 Baris

SELECT
    r.id_reservasi,
    r.nomor_plat,
    tp.jenis_slot,
    tp.tarif_per_jam,
    pb.tarif_parkir AS total_pembayaran,
    pb.metode_pembayaran,
    pb.status_pembayaran,
    pb.tanggal_pembayaran,
    pb.batas_pembayaran
FROM reservasi AS r
JOIN pembayaran AS pb
    ON r.id_reservasi = pb.id_reservasi
JOIN tarif_parkir AS tp
    ON pb.id_tarif = tp.id_tarif
ORDER BY r.id_reservasi;

-- 6. Pertanyaan Bisnis:
-- Bagaimana riwayat parkir beserta status pembayaran
-- milik pengguna?
-- Halaman/Fitur: Halaman pembayaran dan profil pengguna
-- Teknik: JOIN & LEFT JOIN
-- Total Baris : 7 Baris

SELECT
    p.id_pengendara,
    p.nama AS nama_pengendara,
    r.id_reservasi,
    r.nomor_plat,
    r.waktu_mulai,
    r.waktu_selesai,
    r.waktu_masuk,
    r.waktu_keluar,
    r.status_reservasi,
    pb.status_pembayaran,
    pb.tarif_parkir AS total_pembayaran
FROM pengendara AS p
JOIN reservasi AS r
    ON p.id_pengendara = r.id_pengendara
LEFT JOIN pembayaran AS pb
    ON r.id_reservasi = pb.id_reservasi
ORDER BY p.nama, r.waktu_pemesanan DESC;

-- 7. Pertanyaan Bisnis:
-- Apakah terdapat slot parkir yang tidak memiliki reservasi
-- aktif sehingga dapat ditawarkan kepada pengendara?
-- Halaman/Fitur: Pemeriksaan ketersediaan slot sebelum reservasi
-- Teknik: Subquery dengan NOT EXISTS
-- Total Baris : 6 Baris

SELECT
    lp.nama_lokasi,
    ap.lantai,
    sp.id_slot,
    sp.kode_slot,
    sp.jenis_slot,
    sp.status_slot
FROM slot_parkir AS sp
JOIN area_parkir AS ap
    ON sp.id_area = ap.id_area
JOIN lokasi_parkir AS lp
    ON ap.id_lokasi = lp.id_lokasi
WHERE sp.status_slot = 'Tersedia'
  AND NOT EXISTS (
      SELECT 1
      FROM reservasi AS r
      WHERE r.id_slot = sp.id_slot
        AND r.status_reservasi IN (
            'Menunggu Pembayaran',
            'Dikonfirmasi',
            'Berlangsung'
        )
  )
ORDER BY lp.nama_lokasi, ap.lantai, sp.kode_slot;