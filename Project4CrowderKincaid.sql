/*** Joseph Crowder & Victoria Kincaid ***/
/*** Project 4 ***/

/*1. Alter IPEDS HD2019 and EFFY2019 tables to include primary and foreign keys, and the correct data types and length for each field. 20 points*/

/*For this first part here we are setting up our IPEDS database and altering the two tables in two different ways, first we are making sure that the UnitID in
HD2019 cannot be null and will change to primary key clustered. Then we are altering EFFY2019 where it also cannot be NULL and creates a foreign key referencing
the primary key of HD2019. */

USE [IPEDS 2019-2020]
GO

 ALTER TABLE dbo.HD2019
 ALTER COLUMN UNITID INT NOT NULL;

 ALTER TABLE dbo.HD2019
 ADD CONSTRAINT PK_HD2019 PRIMARY KEY CLUSTERED (UNITID);


 ALTER TABLE dbo.EFFY2019
 ALTER COLUMN UNITID INT NOT NULL;

 ALTER TABLE dbo.EFFY2019 WITH CHECK
 ADD FOREIGN KEY (UNITID) REFERENCES HD2019(UNITID);

/*Now that the columns have changed to primary and foreign keys we are going to alter parts of the table to make it faster to run. For instance, there is no point in
FIPS being smallint, smallint can be between -32,768 and 32,767. We can check the maximum amount from FIPS with the SELECT(MAX) statement. From here we see that it is
78, for that we only need TINYINT whose range is 0 to 255. We just took the first eight columns of HD2019 and did this for each. Everyone of the eight could be altered
to save space and subsequently save time when utilizing the table.*/
 
SELECT MAX(LEN(INSTNM)) FROM HD2019;
ALTER TABLE dbo.HD2019 WITH NOCHECK
ADD CHECK (LEN(INSTNM) = 91);
 
SELECT MAX(LEN(IALIAS)) FROM HD2019;
ALTER TABLE dbo.HD2019 WITH NOCHECK
ADD CHECK (LEN(IALIAS) = 680);

SELECT MAX(LEN(ADDR)) FROM HD2019;
ALTER TABLE dbo.HD2019 WITH NOCHECK
ADD CHECK (LEN(ADDR) = 66);

SELECT MAX(LEN(CITY)) FROM HD2019;
ALTER TABLE dbo.HD2019 WITH NOCHECK
ADD CHECK (LEN(CITY) = 24);

SELECT MAX(LEN(ZIP)) FROM HD2019;
ALTER TABLE dbo.HD2019 WITH NOCHECK
ADD CHECK (LEN(ZIP) = 10);

SELECT MAX(FIPS) FROM HD2019;
ALTER TABLE dbo.HD2019
ALTER COLUMN FIPS TINYINT;

SELECT MAX(OBEREG) FROM HD2019;
ALTER TABLE dbo.HD2019
ALTER COLUMN OBEREG TINYINT;

SELECT MAX(LEN(CHFNM)) FROM HD2019;
ALTER TABLE dbo.HD2019 WITH NOCHECK
ADD CHECK (LEN(CHFNM) = 50);


/********2. Create a database for your database system of choice (for example, a storefront, car dealership, hospital, college, etc.), with at least 6 tables 
connected with each other using primary and foreign keys. Use Insert statements to have at least 10 records/rows of data in each table. The database 
object should have the code to drop the object if it exists. This would allow us to run the script to create the database again without having to 
manually drop it first. Comment each section of the code heavily. 80 points ***********/


/* First things first we need to set the master for all databases before creating our own*/
USE master
GO

/* We decided to have some fun with this project and make a database for pokemon! It made the project very enjoyable. So, we need to create our Pokemon database and set it up
so that it "would allow us to run the script to create the database again without having to manually drop it first". */

/****** Object:  Database Pokemon     ******/
IF DB_ID('Pokemon') IS NOT NULL
	DROP DATABASE Pokemon
GO

CREATE DATABASE Pokemon
GO 

USE [Pokemon]
GO


-- I set this up initially to how it was set up in Create_AP.sql file, BUT I kept coming up with this error that led me to the solution from this site:
-- https://dba.stackexchange.com/questions/2387/sql-server-cannot-drop-database-dbname-because-it-is-currently-in-use-but-n/2391
 

-- VERY IMPORTANT!!! Below is only to use if needs to be deleted :/
USE master;
GO
ALTER DATABASE Pokemon SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
DROP DATABASE Pokemon;


/*After the database is set up, it's time to set up each of our individual tables. We are going to do the same where we set up the table so we won't have to manually drop it. This first table is our
main table that is the PokemonType. It will have a primary key that most of our tables will be referencing as foreign keys. The columns are the pokemon ID number, their name, their two types (if they
have two types, if not it will be NULL), if there is a variation in the generation then what generation there was a change in the type, and then the final column is what the new typing would be. For example: Raichu 
is the evolution of Pikachu, and has been around since the first Pokemon game. For the first six generations he was pure Electric type, BUT in generation 7 (Pokemon Sun & Moon) he gained a new Psychic type. The first 
game/generation came out in 1996, the seventh game/generation came out in 2016. That means for twenty years Raichu was pure electric type but for the past five years he has had two typings.*/

/****** Object:  Table [dbo].[PokemonType] ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- TODAY I LEARNED IN ORDER TO DELETE AND REFRESH THESE TABLES YOU NEED TO HAVE USE MASTER GO IN FRONT OF ALL OF THEM!  Which makes sense! You can't delete it if you are still in the datbase using it!
IF OBJECT_ID('PokemonType') IS NOT NULL  
   DROP TABLE [Pokemon].[PokemonType];  
GO

CREATE TABLE PokemonType
(PokemonNo INT IDENTITY(1,1) PRIMARY KEY,
Name VARCHAR(25),
Type1 VARCHAR(10),
Type2 VARCHAR(10),
GenerationVariations VARCHAR(10),
NewType VARCHAR(10));
GO

/*This second table is called Championship Winners. Since 2009 there has been national championships where people have come together and battled their pokemon! Pretty fun to watch, here is a link to the site that was
used to get information on the Winners and tournaments: https://www.vgcpedia.com/world-championships-hub/ In this table we have the Year, City and State (or Province) that the tournament was held, the name of the winner
of the Senior championship (which is age 13-15, in the future I think we will include the winners for the Junior (under 12) and master (over 16) categories)), the country the winner was from, and their first
pokemon on their winning team. This table uses a foreign key and references the primary key of the pokemontype table.*/

/****** Object:  Table [dbo].[ChampionshipWinners] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('ChampionshipWinners') IS NOT NULL  
   DROP TABLE [Pokemon].[ChampionshipWinners];  
GO

CREATE TABLE ChampionshipWinners
(ID INT PRIMARY KEY,
Year VARCHAR(4),
CityHeld VARCHAR(25),
StateHeld VARCHAR(2),
SeniorWinner VARCHAR(50),
SeniorWinnerCountry VARCHAR(50),
WinningPokemon INT FOREIGN KEY REFERENCES PokemonType(PokemonNo));
GO

/*This next table refernces several legendary pokemon. This has a similar foreign key, shows the generation the legendary is from, and the variable of which type of legendary it is for which there are three. It also has a column
of the location for the legendary pokemon.*/

/****** Object:  Table [dbo].[LegendaryPokemon] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('LegendaryPokemon') IS NOT NULL  
   DROP TABLE [Pokemon].[LegendaryPokemon];  
GO

CREATE TABLE LegendaryPokemon
(PokemonNo INT FOREIGN KEY REFERENCES PokemonType(PokemonNo),
Generation VARCHAR(10),
Legendary VARCHAR(3),
Sublegendary VARCHAR(3),
Mythical VARCHAR(3),
Location VARCHAR(30));
GO

/*This next table is from the first game's Gym Leaders. In the game, you battle your pokemon against gym leaders and collect badges. We have listed for columns the Gym Leader ID number, their Name,
their city in the game, the type of gym they have (for instance, Misty canonically has the water type gym), and the pokemon you have to fight in their gym. In the beginning their might be only two pokemon
you need to fight (like Misty has only two pokemon), whereas at the end there is up to five pokmemon you need to fight. The last thing is the level of the pokemon in the gym you need to fight.*/

/****** Object:  Table [dbo].[GymLeaders] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('GymLeaders') IS NOT NULL  
   DROP TABLE [Pokemon].[GymLeaders];  
GO

CREATE TABLE GymLeaders
(GLID INT PRIMARY KEY,
Name VARCHAR(20),
City VARCHAR(20),
Type VARCHAR(20),
Pkmn1 INT FOREIGN KEY REFERENCES PokemonType(PokemonNo),
Pkmn1Lvl VARCHAR(3),
Pkmn2 INT FOREIGN KEY REFERENCES PokemonType(PokemonNo),
Pkmn2Lvl VARCHAR(3),
Pkmn3 INT FOREIGN KEY REFERENCES PokemonType(PokemonNo),
Pkmn3Lvl VARCHAR(3),
Pkmn4 INT FOREIGN KEY REFERENCES PokemonType(PokemonNo),
Pkmn4Lvl VARCHAR(3),
Pkmn5 INT FOREIGN KEY REFERENCES PokemonType(PokemonNo),
Pkmn5Lvl VARCHAR(3));
GO


/*This table is for the evolution of pokemon. As one plays the game with their pokemon they can grow and evolve into new pokemon. This can be done in various formats. For the talbe we have listed the
PokemonNo referencing the PokemonType table, the name, and the format it evolves in. Level means just by leveling it up, Trade means trading it with another person, Stone means having it hold onto a stone, and Mega 
means the pokemon evolves while holding a particular mega stone, the generation shows the generation it came from.*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('Evolution') IS NOT NULL  
   DROP TABLE [Pokemon].[Evolution];  
GO

CREATE TABLE Evolution
(PokemonNo INT FOREIGN KEY REFERENCES PokemonType(PokemonNo),
Name VARCHAR(30),
Level VARCHAR(7),
Trade VARCHAR(20),
Stone VARCHAR(15),
Mega VARCHAR(5),
Generation VARCHAR(10));


/* For our final created table is the encounters. In the pokemon game you have to catch pokemon in certain areas (most of the time), so for the table we have the foreign key PokemonNo, the Name, the
locations you can find the pokemon, which game it is refering to, and the chance rate*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('Encounters') IS NOT NULL  
   DROP TABLE [Pokemon].[Encounters];  
GO

CREATE TABLE Encounters
(PokemonNo INT FOREIGN KEY REFERENCES PokemonType(PokemonNo),
Name VARCHAR(25),
Locations VARCHAR(255),
Game VARCHAR(30),              /* Red Yellow Blue, different spawn for each */
CatchRate VARCHAR(10)); 
GO


/*From here we insert and fill our tables! We have them divided by table to make it easier to read, we have first for our SET IDENTITY_INSERT is the integral PokemonType table, I went to this site
https://docs.microsoft.com/en-us/sql/t-sql/statements/set-identity-insert-transact-sql?view=sql-server-ver15 to verify what it means, it says only one table in a session can have this ON so it made sense
to have it set for this table. From there all the inserts have the IDENITTY_INSERT as OFF.*/

SET IDENTITY_INSERT [dbo].[PokemonType] ON
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (1, N'Bulbasaur', N'Grass', N'Poison', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (6, 'Charizard', 'Fire', 'Flying', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (25, 'Pikachu', 'Electric', NULL, NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (26, 'Raichu', 'Electric', NULL, '7, 8', 'Psychic');
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (31, 'Nidoqueen', 'Poison', 'Ground', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (34, 'Nidoking', 'Poison', 'Ground', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (45, 'Vileplume', 'Grass', 'Poison', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (49, 'Venomoth', 'Bug', 'Poison', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (51, 'Dugtrio', 'Ground', NULL, '7,8', 'Steel');
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (58, 'Growlithe', 'Fire', NULL, NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (59, 'Arcanine', 'Fire', NULL, NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (64, 'Kadabra', 'Psychic', NULL, NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (65, 'Alakazam', 'Psychic', NULL, NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (71, 'Victreebel', 'Grass', 'Poison', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (74, 'Geodude', 'Rock', 'Ground', '7', 'Electric');
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (77, 'Ponyta', 'Fire', NULL, '8', 'Psychic');
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (78, 'Rapidash', 'Fire', NULL, '8', 'Psychic, Fairy');
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (89, 'Muk', 'Poison', NULL, '7', 'Dark');
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (95, 'Onix', 'Rock', 'Ground', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (100, 'Voltorb', 'Electric', NULL, NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (109, 'Koffing', 'Poison', NULL, NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (110, 'Weezing', 'Poison', NULL, '8', 'Fairy');
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (111, 'Rhyhorn', 'Ground', 'Rock', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (112, 'Rhydon', 'Ground', 'Rock', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (114, 'Tangela', 'Grass', NULL, NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (120, 'Staryu', 'Water', NULL, NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (121, 'Starmie', 'Water', 'Psychic', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (122, 'Mr. Mime', 'Psychic', NULL,'6,7,8', 'Fairy, Ice');
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (144,'Articuno', 'Ice', 'Flying', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (145, 'Zapdos', 'Electric', 'Flying', '8', 'Fight');
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (146, 'Moltres', 'Fire', 'Flying', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (150, 'MewTwo', 'Psychic', NULL, NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (151, 'Mew', 'Psychic', NULL, NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (272, 'Ludicolo', 'Water', 'Grass', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (282, 'Gardevoir', 'Psychic', NULL, '6,7,8', 'Fairy');
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (303, 'Mawile', 'Steel', NULL, '6,7,8', 'Fairy');
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (382, 'Kyogre', 'Water', NULL, NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (383, 'Groudon', 'Groud', NULL, NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (384, 'Rayquaza', 'Dragon', 'Flying', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (454, 'Toxicroak', 'Poison', 'Fight', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (642, 'Thundurus', 'Electric','Flying', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (785, 'Tapu Koko', 'Electric', 'Fairy', NULL, NULL);
GO

SET IDENTITY_INSERT [dbo].[PokemonType] OFF
INSERT [dbo].[LegendaryPokemon] ([PokemonNo], [Generation], [Legendary], [Sublegendary], [Mythical], [Location]) VALUES (144, '1', 'NO', 'YES', 'NO', 'Seafoam Island');
INSERT [dbo].[LegendaryPokemon] ([PokemonNo], [Generation], [Legendary], [Sublegendary], [Mythical], [Location]) VALUES (145, '1', 'NO', 'YES', 'NO', 'Power Plant');
INSERT [dbo].[LegendaryPokemon] ([PokemonNo], [Generation], [Legendary], [Sublegendary], [Mythical], [Location]) VALUES (146, '1', 'NO', 'YES', 'NO', 'Victory Road');
INSERT [dbo].[LegendaryPokemon] ([PokemonNo], [Generation], [Legendary], [Sublegendary], [Mythical], [Location]) VALUES (150, '1', 'YES', 'NO', 'NO', 'Unknown Dungeon');
INSERT [dbo].[LegendaryPokemon] ([PokemonNo], [Generation], [Legendary], [Sublegendary], [Mythical], [Location]) VALUES (151, '1', 'NO', 'NO', 'YES', NULL);
INSERT [dbo].[LegendaryPokemon] ([PokemonNo], [Generation], [Legendary], [Sublegendary], [Mythical], [Location]) VALUES (382, '3', 'YES', 'NO', 'NO', 'Marine Cave');
INSERT [dbo].[LegendaryPokemon] ([PokemonNo], [Generation], [Legendary], [Sublegendary], [Mythical], [Location]) VALUES (383, '3', 'YES', 'NO', 'NO', 'Mountain Cave');
INSERT [dbo].[LegendaryPokemon] ([PokemonNo], [Generation], [Legendary], [Sublegendary], [Mythical], [Location]) VALUES (384, '3', 'YES', 'NO', 'NO', 'Sky Pillar');
INSERT [dbo].[LegendaryPokemon] ([PokemonNo], [Generation], [Legendary], [Sublegendary], [Mythical], [Location]) VALUES (642, '5', 'NO', 'YES', 'NO', 'Roaming');
INSERT [dbo].[LegendaryPokemon] ([PokemonNo], [Generation], [Legendary], [Sublegendary], [Mythical], [Location]) VALUES (785, '7', 'NO', 'YES', 'NO', 'Ruins of Conflict');
GO

INSERT [dbo].[GymLeaders] (GLID, Name, City, Type, Pkmn1, Pkmn1Lvl, Pkmn2, Pkmn2Lvl, Pkmn3, Pkmn3Lvl, Pkmn4, Pkmn4Lvl, Pkmn5, Pkmn5Lvl) VALUES (1, 'Brock', 'Pewter', 'Rock', 74, '12', 95, '14', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT [dbo].[GymLeaders] (GLID, Name, City, Type, Pkmn1, Pkmn1Lvl, Pkmn2, Pkmn2Lvl, Pkmn3, Pkmn3Lvl, Pkmn4, Pkmn4Lvl, Pkmn5, Pkmn5Lvl) VALUES (2, 'Misty', 'Cerulean', 'Water', 120, '18', 121, '21',  NULL, NULL, NULL, NULL, NULL, NULL);
INSERT [dbo].[GymLeaders] (GLID, Name, City, Type, Pkmn1, Pkmn1Lvl, Pkmn2, Pkmn2Lvl, Pkmn3, Pkmn3Lvl, Pkmn4, Pkmn4Lvl, Pkmn5, Pkmn5Lvl) VALUES (3, 'Lt. Surge', 'Vermillion', 'Electric', 100, '21', 25, '18', 26, '24', NULL, NULL, NULL, NULL);
INSERT [dbo].[GymLeaders] (GLID, Name, City, Type, Pkmn1, Pkmn1Lvl, Pkmn2, Pkmn2Lvl, Pkmn3, Pkmn3Lvl, Pkmn4, Pkmn4Lvl, Pkmn5, Pkmn5Lvl) VALUES (4, 'Erika', 'Celadon', 'Grass', 71, '29', 114, '24', 45, '29', NULL, NULL, NULL, NULL);
INSERT [dbo].[GymLeaders] (GLID, Name, City, Type, Pkmn1, Pkmn1Lvl, Pkmn2, Pkmn2Lvl, Pkmn3, Pkmn3Lvl, Pkmn4, Pkmn4Lvl, Pkmn5, Pkmn5Lvl) VALUES (5, 'Koga', 'Fuchsia', 'Poison', 109, '37', 89, '39', 109, '37', 110, '43', NULL, NULL);
INSERT [dbo].[GymLeaders] (GLID, Name, City, Type, Pkmn1, Pkmn1Lvl, Pkmn2, Pkmn2Lvl, Pkmn3, Pkmn3Lvl, Pkmn4, Pkmn4Lvl, Pkmn5, Pkmn5Lvl) VALUES (6, 'Sabrina', 'Saffron', 'Psychic', 64, '38', 122, '37', 49, '38', 65, '43', NULL, NULL);
INSERT [dbo].[GymLeaders] (GLID, Name, City, Type, Pkmn1, Pkmn1Lvl, Pkmn2, Pkmn2Lvl, Pkmn3, Pkmn3Lvl, Pkmn4, Pkmn4Lvl, Pkmn5, Pkmn5Lvl) VALUES (7, 'Blaine', 'Cinnabar', 'Fire', 58, '42', 77, '40', 78, '42', 59, '47', NULL, NULL);
INSERT [dbo].[GymLeaders] (GLID, Name, City, Type, Pkmn1, Pkmn1Lvl, Pkmn2, Pkmn2Lvl, Pkmn3, Pkmn3Lvl, Pkmn4, Pkmn4Lvl, Pkmn5, Pkmn5Lvl) VALUES (8, 'Giovanni', 'Viridian', 'Ground', 111, '45', 51, '42',  31, '44', 34, '45', 112, '50');
GO

INSERT [dbo].[ChampionshipWinners] (ID, Year, CityHeld, StateHeld, SeniorWinner, SeniorWinnerCountry, WinningPokemon) VALUES (1, '2009', 'San Diego', 'CA', 'Kazuyuki Tsuji', 'Japan', 454);
INSERT [dbo].[ChampionshipWinners] (ID, Year, CityHeld, StateHeld, SeniorWinner, SeniorWinnerCountry, WinningPokemon) VALUES (2, '2010', 'Waikoloa Village', 'HI','Ray Rizzo', 'USA', 382);
INSERT [dbo].[ChampionshipWinners] (ID, Year, CityHeld, StateHeld, SeniorWinner, SeniorWinnerCountry, WinningPokemon) VALUES (3, '2011', 'San Diego', 'CA', 'Kamran Jahadi', 'USA', 642);
INSERT [dbo].[ChampionshipWinners] (ID, Year, CityHeld, StateHeld, SeniorWinner, SeniorWinnerCountry, WinningPokemon) VALUES (4, '2012', 'Waikoloa Village', 'HI', 'Toler Webb', 'USA', 272);
INSERT [dbo].[ChampionshipWinners] (ID, Year, CityHeld, StateHeld, SeniorWinner, SeniorWinnerCountry, WinningPokemon) VALUES (5, '2013', 'Vancouver', 'BC', 'Hayden McTavish', 'USA', 642);
INSERT [dbo].[ChampionshipWinners] (ID, Year, CityHeld, StateHeld, SeniorWinner, SeniorWinnerCountry, WinningPokemon) VALUES (6, '2014', 'Washington', 'DC', 'Nikolai Zielinski', 'USA', 303);
INSERT [dbo].[ChampionshipWinners] (ID, Year, CityHeld, StateHeld, SeniorWinner, SeniorWinnerCountry, WinningPokemon) VALUES (7, '2015', 'Boston', 'MA', 'Mark McQuillan', 'England', 6);
INSERT [dbo].[ChampionshipWinners] (ID, Year, CityHeld, StateHeld, SeniorWinner, SeniorWinnerCountry, WinningPokemon) VALUES (8, '2016', 'San Francisco', 'CA', 'Carson Confer', 'USA', 383);
INSERT [dbo].[ChampionshipWinners] (ID, Year, CityHeld, StateHeld, SeniorWinner, SeniorWinnerCountry, WinningPokemon) VALUES (9, '2017', 'Anaheim', 'CA', 'Hong Juyoung', 'Japan', 785);
INSERT [dbo].[ChampionshipWinners] (ID, Year, CityHeld, StateHeld, SeniorWinner, SeniorWinnerCountry, WinningPokemon) VALUES (10, '2018', 'Nashville', 'TN', 'James Evans', 'USA', 282);
INSERT [dbo].[ChampionshipWinners] (ID, Year, CityHeld, StateHeld, SeniorWinner, SeniorWinnerCountry, WinningPokemon) VALUES (11, '2019', 'Washington', 'DC', 'Ko Tsukide', 'Japan', 384);
GO

INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (1, 'Bulbasaur', '16', NULL,  NULL, NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (25, 'Pikachu', NULL, NULL, 'Thunder', NULL, '1, 7');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (26, 'Raichu', NULL, NULL, NULL, NULL, '1, 7');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (31, 'Nidoqueen', NULL, NULL, NULL, NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (34, 'Nidoking', NULL, NULL, NULL, NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (45, 'Vileplume', NULL, NULL, NULL, NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (49, 'Venomoth', NULL, NULL, NULL, NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (51, 'Dugtrio', NULL, NULL, NULL, NULL, '1, 7');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (58, 'Growlithe', NULL, NULL, 'Fire', NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (59, 'Arcanine', NULL, NULL, NULL, NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (64, 'Kadabra', NULL, 'Trade', NULL, NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (65, 'Alakazam', NULL, NULL, NULL, 'Mega', '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (71, 'Victreebel', NULL, NULL, NULL, NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (74, 'Geodude', '25', NULL, NULL, NULL, '1, 7');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (77, 'Ponyta', '40', NULL, NULL, NULL, '1, 8');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (78, 'Rapidash', NULL, NULL, NULL, NULL, '1, 8'); 
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (89, 'Muk', NULL, NULL, NULL, NULL, '1, 7');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (95, 'Onix', NULL, 'TradeWithMetalCoat', NULL, NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (100, 'Voltorb', '30', NULL,  NULL, NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (110, 'Weezing', NULL, NULL, NULL, NULL, '1, 8');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (111, 'Rhyhorn', '42', NULL,  NULL, NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (112, 'Rhydon', NULL, 'TradeWithProtector', NULL, NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (114, 'Tangela', 'Random', NULL, NULL, NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (120, 'Staryu', NULL, NULL, 'Water', NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (121, 'Starmie', NULL, NULL, NULL, NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (122, 'Mr. Mime', NULL, NULL, NULL, NULL, '1, 8'); 
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (144,'Articuno', NULL, NULL, NULL, NULL, '1, 8');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (145, 'Zapdos', NULL, NULL, NULL, NULL, '1, 8');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (146, 'Moltres', NULL, NULL, NULL, NULL, '1, 8');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (150, 'MewTwo', NULL, NULL, NULL, 'Mega', '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (151, 'Mew', NULL, NULL, NULL, NULL, '1');

INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (1, 'Bulbasaur', 'ProfessorOak', 'Red, Blue', NULL);
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (25, 'Pikachu', 'ProfessorOak, VirdianForest, PowerPlant', 'Red, Blue, Yellow', '35.2');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (26, 'Raichu', 'Evolution, PowerPlant, CeruleanCave', 'Red, Blue', '17.5')
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (31, 'Nidoqueen', 'Evolution', 'Red, Blue, Yellow', NULL);
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (34, 'Nidoking', 'Evolution', 'Red, Blue, Yellow', NULL);
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (45, 'Vileplume', 'Evolution, Trade', 'Red, Blue, Yellow', '11.9');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (49, 'Venomoth', 'Evolution, SafariZone, VictoryRoad, CureleanCave, Route14, Route15', 'Red, Blue, Yellow', '17.5');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (51, 'Dugtrio', 'Evolution, DiglettsCave, TradeOnRoute11', 'Red, Blue, Yellow', '12.9');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (58, 'Growlithe', 'Route7, Route8, PokemonMansion, Trade', 'Red, Blue, Yellow', '35.2');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (59, 'Arcanine', 'Evolution, Trade', 'Red, Blue, Yellow', '17.5');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (64, 'Kadabra', 'Evolution, CeruleanCave, Route8', 'Red, Blue, Yellow', '21.7');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (65, 'Alakazam', 'Evolution', 'Red, Blue, Yellow', NULL);
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (71, 'Victreebel', 'Evolution, Trade', 'Red, Blue, Yellow', NULL);
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (74, 'Geodude', 'MountMoon, RockTunnel, VictoryRoad', 'Red, Blue, Yellow', '43.9');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (77, 'Ponyta', 'PokemonMansion, Route17', 'Red, Blue, Yellow', '35.2');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (78, 'Rapidash', 'Evolution, CeruleanCave', 'Red, Blue, Yellow', '14.8');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (89, 'Muk', 'Evolution, PokemonMansion, PowerPlant, TradeAtPokeLab', 'Red, Blue, Yellow', '17.5');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (95, 'Onix', 'RockTunnel, VictoryRoad', 'Red, Blue, Yellow', '11.9');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (100, 'Voltorb', 'Route10, PowerPlant', 'Red, Blue, Yellow', '35.2');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (110, 'Weezing', 'Evolution, PokemonMansion, Trade', 'Red, Blue, Yellow', '14.8');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (111, 'Rhyhorn', 'SafariZone, CeruleanCave', 'Red, Blue, Yellow', '24.9');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (112, 'Rhydon', 'Evolution, CeruleanCave, TradeAtPokeLab', 'Red, Blue, Yellow', '14.8');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (114, 'Tangela', 'Route21, SafariZone, TradeAtPokeLab', 'Red, Blue, Yellow', '11.9');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (120, 'Staryu', 'SeafoamIslands, Route19, Route20, Route21, Cinnabar Island, Pallet Town', 'Red, Blue, Yellow', '39.9');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (121, 'Starmie', 'Evolution', 'Red, Blue, Yellow', NULL);
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (122, 'Mr. Mime', 'TradeOnRoute2', 'Red, Blue, Yellow', NULL);
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (144,'Articuno', 'SeafoamIslands', 'Red, Blue, Yellow', '1.6')
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (145, 'Zapdos', 'PowerPlant', 'Red, Blue, Yellow', '1.6')
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (146, 'Moltres', 'VictoryRoad', 'Red, Blue, Yellow', '1.6')
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (150, 'MewTwo', 'CeruleanCave', 'Red, Blue, Yellow', '1.6')
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (151, 'Mew', 'GlitchOrEventIn1999', 'Red, Blue, Yellow', '1.6')