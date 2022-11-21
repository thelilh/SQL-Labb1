# Labb 1 - SQL-Databas f�r Bokhandel

Vi vill bygga en databas som kan anv�ndas till en bokhandel med flera butiker.
</br>
</br>
Du f�r i uppgift att designa den i SQL-server med nycklar, relationer,
integritetsvilkor och ett ER-diagram. Nedan finns n�gra minimikrav p� tabeller
och vyer vi vill ha med, men d�rut�ver vill vi att du l�gger till ytterligare ett
antal tabeller som du tror att vi f�r anv�ndning f�r. Vi vill �ven att du populerar
databasen med l�mpliga testdata f�r demonstrationssyfte.

## Tabell: �F�rfattare�

I tabellen f�rfattare vill vi ha en �Identietskolumn� (identity) kallad ID som PK.
D�rut�ver vill vi ha kolumnerna: F�rnamn, Efternamn och F�delsedatum i
passande datatyper.

## Tabell: �B�cker�
I tabellen b�cker vill vi ha ISBN13 som prim�rnyckel med l�mpliga constraints.
Ut�ver det vill vi ha kolumnerna: Titel, Spr�k, Pris, och Utgivningsdatum av
passande datatyper. Sist vill vi ha en FK-kolumn �F�rfattareID� som pekar mot
tabellen �F�rfattare�. Ut�ver dessa kolumner f�r du g�rna l�gga till egna med
information som du tycker kan vara bra att lagra om varje bok.

## Tabell: �Butiker�
Ut�ver ett identity-ID s� beh�ver tabellen kolumner f�r att lagra butiksnamn
samt addressuppgifter.


## Tabell: �LagerSaldo�
I denna tabell vill vi ha 3 kolumner: ButikID som kopplas mot Butiker, ISBN som
kopplas mot b�cker, samt Antal som s�ger hur m�nga exemplar det finns av en
given bok i en viss butik. Som PK vill vi ha en kompositnyckel p� kolumnerna
ButikID och ISBN. 


## �vriga tabeller
De 4 tabellerna som �r specificerade ovan �r ett minimum att implementera.
Ut�ver det ska du dock l�gga till ytterligare minst 2 tabeller (minst 4 f�r VG)
med information som kan vara l�mplig att lagra f�r bokhandelns syfte, och
skapa nycklar och relationer mellan dessa.
Exempel p� tabeller skulle kunna vara �Kunder�, �Ordrar� och �F�rlag�. Vad
beh�ver man spara f�r uppgifter i de olika tabellerna? Vad f�r andra tabeller
kan vi beh�va? Hur kommer de vara relaterade till varandra och v�ra 4 tidigare
tabeller? Eventuellt kan vi beh�va uppdatera v�ra 4 tidigare tabeller med
kolumner f�r att relatera till de nya.

## Demodata
F�r demonstration vill vi ha minst 3 butiker, 4 f�rfattare, 10 boktitlar med
tillh�rande saldo. I tabeller du sj�lv skapar l�gger du till l�mpliga testdata f�r
att vi ska kunna demonstrera uppl�gget.

## Vy: �TitlarPerF�rfattare�
Vi vill �ven ha en vy som sammanst�ller data fr�n tabellerna. Vyn ska inneh�lla
f�ljande 4 kolumner (med en rad per f�rfattare):
�Namn� � Hela namnet p� f�rfattaren.
��lder� � Hur gammal f�rfattaren �r.
�Titlar� � Hur m�nga olika titlar vi har i �B�cker� av den angivna f�rfattaren.
�Lagerv�rde� � Totala v�rdet (pris) f�r f�rfattarens b�cker i samtliga butiker.
Exempel data: �select top 1 * from TitlarPerF�rfattare�
Namn �lder Titlar Lagerv�rde
Emma Askling 43 �r 3 st 4182 kr 

## SP: �FlyttaBok� (VG)
Vi vill att det ska finnas en stored procedure i databasen som p� ett
integritetss�kert s�tt flyttar exemplar av b�cker fr�n en butik till en annan. Den
ska ta en parameter med ID p� butik som man flyttar fr�n, en parameter med
ID p� butik man flyttar till, ett ISBN, samt en valbar (optional) fj�rde parameter
som tar antal exemplar man vill flytta (default = 1). Vilka h�nsyn beh�ver vi ta
f�r dataintegritet?

## Flera f�rfattare p� samma bok (VG)
F�r VG, uppdatera relationen f�rfattare/b�cker fr�n one-many till en manymany relation, s� att vi kan lagra b�cker med flera f�rfattare i systemet.

## En extra vy (VG)
Skapa ytterligare en vy som sammanst�ller f�r bokhandeln relevant
information fr�n minst tv� av de tabeller som du lagt till under rubriken ��vriga
tabeller�. F�r att n� upp till VG-niv� b�r vyn inneh�lla n�gon form att
aggregering/gruppering. Man ska �ven skriva med en kommentar (i koden eller
vid inl�mning) som motiverar hur bokhandeln kan ha nytta av den
sammanst�llda vyn.

## �vrigt
T�nk p� att v�lja l�mpliga datatyper och s�tta integritetsvilkor d�r du anser det
l�mpligt. Databasen ska inneh�lla ett ER-diagram som visar relationerna mellan
alla tabeller p� ett tydligt s�tt.

## Redovisning
Uppgiften kan g�ras sj�lvst�ndig eller i par. Om ni jobbar i par s� ska ni skriva
en kommentar p� ithsdistans vem ni jobbat ihop med.
Ta en backup av den f�rdiga databasen och d�p den till ditt f�r- och efternamn.
Exempel: �NiklasHjelm.bak�. Ladda upp filen f�r inl�mning p� ITHSdistans.

## Betygskriterier
### F�r godk�nt kr�vs:
* Databasen ska inneh�lla minst 6 (4+2) tabeller relevanta f�r bokhandeln.
* Tabeller ska vara normaliserade enligt 3NF.
* Alla relationer ska ha PK och FK nycklar, samt relationsvilkor som
f�rhindrar FK�s att peka p� nycklar som inte existerar.
* Kolumner ska anv�nda l�mpliga datatyper f�r den typ av information
som ska lagras.
* Databasen ska inneh�lla ett ER-diagram som visar relationerna mellan
alla tabeller p� ett tydligt s�tt.
* Databasen ska inneh�lla l�mpliga testdata f�r demonstration.
* Databasen ska inneh�lla vyn �TitlarPerF�rfattare� enligt specifikation.
### F�r v�l godk�nt kr�vs �ven:
* Databasen ska inneh�lla minst 8 (4+4) tabeller relevanta f�r bokhandeln.
(Det ska vara minst 8 entiteter. Junktion tables r�knas ej.)
* Databasen �r gjord s� b�cker kan ha flera f�rfattare.
* Databasen ska inneh�lla SP �FlyttaBok� enligt specifikation.
* Databasen har ytterligare en vy som sammanst�ller f�r bokhandeln
relevant information fr�n minst tv� av de tabeller som du lagt till under
rubriken ��vriga tabeller�. Motivera hur bokhandeln kan ha nytta av den
sammanst�llda vyn.