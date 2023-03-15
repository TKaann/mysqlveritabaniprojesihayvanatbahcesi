create database hayvanatbahcesi;
create database bp_20015221023;

use bp_20015221023;

create table hayvan_turleri(
tur_id int primary key,
tur_adi varchar(25)
)engine=innodb;

alter table hayvan_turleri add tur_yasadigi_kita varchar(40);
alter table hayvan_turleri add tur_beslenme_sekli varchar(40);
alter table hayvan_turleri add tur_bakim_saati varchar(40);

create table bakicilar(
bakici_id int primary key,
bakici_isim varchar(25)
)engine=innodb;

alter table bakicilar add bakici_soyisim varchar(40);
alter table bakicilar add bakici_calisma_saati varchar(40);
alter table bakicilar add bakici_ev_adresi varchar(40);

create table hayvanlar(
hayvan_id int primary key,
hayvan_isim varchar (25),
tur_id int,
foreign key (tur_id)
	references hayvan_turleri(tur_id)
	on delete cascade,
bakici_id int,
foreign key(bakici_id)
	references bakicilar(bakici_id)
    on delete cascade
)engine=InnoDB;

alter table hayvanlar add hayvanlar_adet varchar(40);

create table musteri(
musteri_id int auto_increment primary key,
musteri_adi varchar(25) not null,
musteri_soyadi varchar(25) not null,
musteri_adres varchar (70) null,
musteri_tel varchar(11) not null,
unique(musteri_tel)
)engine=innodb;

create table bilet(
bilet_id int auto_increment not null primary key,
bilet_tarihi date,
bilet_turu varchar(25),

musteri_id int,
foreign key(musteri_id)
	references musteri(musteri_id)
    on delete cascade
)engine=innodb;

-- stored procedure ile veri girisi
delimiter //
create procedure tur_ekle(
	tur_id					int,
	tur_adi					varchar(25),
	tur_yasadigi_kita 		varchar(40),
	tur_beslenme_sekli		varchar(40),
	tur_bakim_saati			varchar(40)
	)
begin
	insert into hayvan_turleri
    values(tur_id, tur_adi, tur_yasadigi_kita, tur_beslenme_sekli, tur_bakim_saati);
end //
delimiter ;

call tur_ekle (1 , 'kanatli_hayvan', 'afrika', 'et', '12:00');
-- stored procedure ile veri girisi sonu


-- stored procedure ile veri sorgulama
DELIMITER //
CREATE PROCEDURE tur_adi_ara(in tur_adi_gir varchar(25) )
BEGIN
select * from hayvan_turleri where tur_adi = tur_adi_gir;
END //
DELIMITER ;

call tur_adi_ara('kanatli_hayvan');
-- stored procedure ile veri sorgulama sonu

delimiter // 

-- stored procedure ile veri guncelleme
create procedure hayvan_turleri_gunvelleme(

	id				int,
	adi				varchar(25),
	kita			varchar(40),
	beslenme		varchar(40),
	saat			varchar(40)
)

begin
	update	hayvan_turleri
    set		tur_id = id, tur_adi = adi, tur_yasadigi_kita = kita, tur_beslenme_sekli = beslenme, tur_bakim_saati = saat
    where tur_id = id;
end //
delimiter ;

call hayvan_turleri_gunvelleme(2 , 'surungen' , 'asya', 'otobur' , '00:00');
-- stored procedure ile veri guncelleme sonu


-- stored procedure ile veri silme
delimiter // 
create procedure hayvan_tur_silme(
	id		int
)
begin
	delete from hayvan_turleri
    where		tur_id = id;
end //
delimiter ;

call hayvan_tur_silme(2);
-- stored procedure ile veri silme sonu


-- tarnsaction kullanimi
create table hesaplar(
hesap_id int,
bakiye int,
hesap_ismi varchar (40)
)engine=innodb;

delimiter //
create procedure hesap_veri_girisi(
	hesap_id				int,
	bakiye					int,
    hesap_ismi				varchar(40)
	)
begin
	insert into hesaplar
    values(hesap_id, bakiye,hesap_ismi);
end //
delimiter ;

call hesap_veri_girisi (0,'1000','musteri_hesap');

call hesap_veri_girisi (1, '2000','bahce_hesap');


delimiter //
create procedure para_transferi(in gidenH int, in gelenH int, in miktar int)
begin
start transaction;
	select bakiye into @bakiyeler from hesaplar where hesap_id = gidenH;
if @bakiyeler < miktar then
	select"Yetersiz Bakiye";
else
	update hesaplar set bakiye = bakiye-miktar where hesap_id = gidenH;
	update hesaplar set bakiye = bakiye+miktar where hesap_id = gelenH;
commit;
end if;
rollback;
end //
delimiter ;

SET SQL_SAFE_UPDATES = 0;
call para_transferi(0,1,1000);
select * from hesaplar;



