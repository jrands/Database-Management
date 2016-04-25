DROP USER IF EXISTS ProfessorOak;
DROP USER IF EXISTS ProfessorElm;
DROP USER IF EXISTS Bill;
DROP USER IF EXISTS Brock;
DROP USER IF EXISTS Misty;
DROP USER IF EXISTS Surge;
DROP USER IF EXISTS Red;
DROP USER IF EXISTS Blue;
DROP USER IF EXISTS Joey;
DROP ROLE IF EXISTS Trainer;
DROP ROLE IF EXISTS Leader;
DROP ROLE IF EXISTS Administrator;
DROP VIEW IF EXISTS PokemonLocations;
DROP VIEW IF EXISTS GymLeaderWeakness;
DROP VIEW IF EXISTS GymLeaderLocations;
DROP TABLE IF EXISTS TypeWeakness;
DROP TABLE IF EXISTS TypeStrength;
DROP TABLE IF EXISTS Evolution;
DROP TABLE IF EXISTS TypeCombo;
DROP TABLE IF EXISTS Team;
DROP TABLE IF EXISTS Inhabitants;
DROP TABLE IF EXISTS GymLeader;
DROP TABLE IF EXISTS Moveset;
DROP TABLE IF EXISTS Move;
DROP TABLE IF EXISTS Type;
DROP TABLE IF EXISTS Location;
DROP TABLE IF EXISTS Pokemon;
DROP TYPE IF EXISTS EvolvesByEnum;
DROP TYPE IF EXISTS LearnedByEnum;
DROP TYPE IF EXISTS RegionEnum;
DROP TYPE IF EXISTS LocEnum;
DROP TYPE IF EXISTS ElemType;

--Elemental Type--
CREATE TYPE ElemType as ENUM ('Normal', 'Fighting', 'Flying', 'Fire', 'Water', 'Grass', 'Poison', 'Electric', 'Ground', 'Psychic', 'Rock', 'Ice', 'Bug', 'Dragon', 'Ghost', 'Dark', 'Steel', 'Fairy');

--Location Type--
CREATE TYPE LocEnum as ENUM('city', 'road', 'grass', 'forest', 'fog', 'mountain', 'ocean', 'marsh', 'ash', 'ruins', 'sand', 'lake', 'underwater', 'cave', 'volcano', 'snow', 'building');

--Region Type--
CREATE TYPE RegionEnum as ENUM ('Kanto', 'Johto', 'Hoenn', 'Sinnoh', 'Unova', 'Kalos');

--LearnedBy Type--
CREATE TYPE LearnedByEnum as ENUM('Level up', 'Starts with', 'TM/HM', 'Breeding', 'Move tutor');

--EvolvesBy Type--
CREATE TYPE EvolvesByEnum as ENUM('Level up', 'Item', 'Trading', 'Happiness', 'Other' );

--Pokemon Table--
CREATE TABLE Pokemon (
  PokemonName text not null,
  DexNumber integer not null check (DexNumber > 0),
  DexEntry text not null,
  Height float not null check (Height > 0),
  Weight float not null check (Weight > 0),
  PRIMARY KEY (PokemonName)
);

--Location Table--
CREATE TABLE Location (
  LocID serial not null,
  LocName text not null,
  LocType LocEnum,
  Region RegionEnum,
  PRIMARY KEY (LocID)
);

--Type Table--
CREATE TABLE Type (
  TypeName text not null unique,
  PRIMARY KEY (TypeName)
);

--Move Table--
CREATE TABLE Move (
  MoveName text not null,
  TypeName text not null references Type(TypeName),
  PP integer not null check (PP > 0),
  Power integer check (Power > 0),
  Accuracy integer check (Accuracy >= 0 and Accuracy <= 100),
  PRIMARY KEY (MoveName)
);

--Moveset Table--
CREATE TABLE Moveset (
  PokemonName text not null references Pokemon(PokemonName),
  MoveName text not null references Move(MoveName), 
  LearnedBy LearnedByEnum not null,
  PRIMARY KEY (PokemonName, MoveName)
);

--Gym Leader Table--
CREATE TABLE GymLeader (
  LeaderName text not null,
  TypeName text references Type(TypeName), 
  LocID integer references Location(LocID) not null,
  BadgeName text not null,
  PRIMARY KEY (LeaderName)
);

--Inhabitants Table--
CREATE TABLE Inhabitants (
  LocID integer not null references Location(LocID) not null,
  PokemonName text references Pokemon(PokemonName) not null, 
  PRIMARY KEY (LocID, PokemonName)
);

--Team Table--
CREATE TABLE Team (
  LeaderName text not null references GymLeader(LeaderName) not null ,
  PokemonName text references Pokemon(PokemonName) not null, 
  PRIMARY KEY (LeaderName, PokemonName)
);

--Type Combo Table--
CREATE TABLE TypeCombo (
  PokemonName text references Pokemon(PokemonName) not null, 
  TypeName text not null references Type(TypeName) not null,
  PRIMARY KEY (PokemonName, TypeName)
);

--Type Weakness Table--
CREATE TABLE TypeWeakness (
  TypeName text not null references Type(TypeName) not null,
  TypeWeakness text not null references Type(TypeName) not null
);

--Type Strength Table--
CREATE TABLE TypeStrength (
  TypeName text not null references Type(TypeName) not null,
  TypeStrength text not null references Type(TypeName) not null
);

--Evolution Table--
CREATE TABLE Evolution (
  PokemonName text references Pokemon(PokemonName) not null,
  EvolutionName text references Pokemon(PokemonName) not null unique,
  EvolvesBy EvolvesByEnum not null,
  PRIMARY KEY (PokemonName, EvolutionName)
);

--Pokemon Inserts--
INSERT INTO Pokemon VALUES 
  ('Bulbasaur', 1, 'Seed Pokemon', 0.7, 6.9), 
  ('Ivysaur', 2, 'Seed Pokemon', 1.0, 13.0), 
  ('Venusaur', 3, 'Seed Pokemon', 2.0, 100.0), 
  ('Charmander', 4, 'Lizard Pokemon', 0.6, 8.5), 
  ('Charmeleon', 5, 'Flame Pokemon', 1.1, 19.0), 
  ('Charizard', 6, 'Flame Pokemon', 1.7, 90.5), 
  ('Squirtle', 7, 'Tiny Turtle Pokemon', 0.5, 9.0),
  ('Wartortle', 8, 'Turtle Pokemon', 1.0, 22.5),
  ('Blastoise', 9, 'Shellfish Pokemon', 1.6, 85.5),
  ('Caterpie', 10, 'Worm Pokemon', 0.3, 2.9),
  ('Metapod', 11, 'Cocoon Pokemon', 0.7, 9.9),
  ('Butterfree', 12, 'Butterfly Pokemon', 1.1, 32.0),
  ('Weedle', 13, 'Hairy Bug Pokemon', 0.3, 3.2),
  ('Kakuna', 14, 'Cocoon Pokemon', 0.3, 10.0),
  ('Beedrill', 15, 'Poison Bee Pokemon', 1.0, 29.5),
  ('Pidgey', 16, 'Tiny Bird', 0.3, 1.8),
  ('Pidgeotto', 17, 'Bird', 1.1, 30.0),
  ('Pidgeot', 18, 'Bird', 1.5, 39.5),
  ('Rattata', 19, 'Mouse', 0.3, 3.5),
  ('Raticate', 20, 'Mouse', 0.7, 18.5),
  ('Spearow', 21, 'Tiny Bird', 0.3, 2.0),
  ('Fearow', 22, 'Beak Pokemon', 1.2, 38.0),
  ('Ekans', 23, 'Snake Pokemon', 2.0, 6.9),
  ('Arbok', 24, 'Cobra Pokemon', 3.5, 65.0),
  ('Pikachu', 25, 'Mouse Pokemon', 0.4, 6.0),
  ('Raichu', 26, 'Mouse Pokemon', 0.8, 30.0),
  ('Sandshrew', 27, 'Mouse Pokemon', 0.6, 12.0),
  ('Sandslash', 28, 'Mouse Pokemon', 1.0, 29.5),
  ('Nidoran♀', 29, 'Poison Pin Pokemon', 0.4, 7.0),
  ('Nidorina', 30, 'Poison Pin Pokemon', 0.8, 20.0),
  ('Nidoqueen', 31, 'Drill Pokemon', 1.3, 60.0),
  ('Nidoran♂', 32, 'Poison Pin Pokemon', 0.5, 9.0),
  ('Nidorino', 33, 'Poison Pin Pokemon', 0.9, 19.5),
  ('Nidoking', 34, 'Drill Pokemon', 1.4, 62.0),
  ('Clefairy', 35, 'Fairy Pokemon', 0.6, 7.5),
  ('Clefable', 36, 'Fairy Pokemon', 1.3, 40.0),
  ('Vulpix', 37, 'Fox Pokemon', 0.6, 9.9),
  ('Ninetales', 38, 'Fox Pokemon', 1.1, 19.9),
  ('Jigglypuff', 39, 'Balloon Pokemon', 0.5, 5.5),
  ('Wigglytuff', 40, 'Balloon Pokemon', 1.0, 12.0),
  ('Zubat', 41, 'Bat Pokemon', 0.8, 7.5),
  ('Golbat', 42, 'Bat Pokemon', 1.6, 55.0),
  ('Oddish', 43, 'Weed Pokemon', 0.5, 5.4),
  ('Gloom', 44, 'Weed Pokemon', 0.8, 8.6),
  ('Vileplume', 45, 'Flower Pokemon', 1.2, 18.6),
  ('Paras', 46, 'Mushroom Pokemon', 0.3, 5.4),
  ('Parasect', 47, 'Mushroom Pokemon', 1.0, 29.5),
  ('Venonat', 48, 'Insect Pokemon', 1.0, 30.0),
  ('Venomoth', 49, 'Poison Moth Pokemon', 1.5, 12.5),
  ('Diglett', 50, 'Mole Pokemon', 0.2, 0.8),
  ('Dugtrio', 51, 'Mole Pokemon', 0.7, 33.3),
  ('Meowth', 52, 'Scratch Cat Pokemon', 0.4, 4.2),
  ('Persian', 53, 'Classy Cat Pokemon', 1.0, 32.0),
  ('Psyduck', 54, 'Duck Pokemon', 0.8, 19.6),
  ('Golduck', 55, 'Duck Pokemon', 1.7, 76.6),
  ('Mankey', 56, 'Pig Monkey Pokemon', 0.5, 28.0),
  ('Primeape', 57, 'Pig Monkey Pokemon', 1.0, 32.0),
  ('Growlithe', 58, 'Puppy Pokemon', 0.7, 19.0),
  ('Arcanine', 59, 'Legendary Pokemon', 1.9, 155.0),
  ('Poliwag', 60, 'Tadpole Pokemon', 0.6, 12.4),
  ('Poliwhirl', 61, 'Tadpole Pokemon', 1.0, 20.0),
  ('Poliwrath', 62, 'Tadpole Pokemon', 1.3, 54.0),
  ('Abra', 63, 'Psi Pokemon', 0.9, 19.5),
  ('Kadabra', 64, 'Psi Pokemon', 1.3, 56.5),
  ('Alakazam', 65, 'Psi Pokemon', 1.5, 48.0),
  ('Machop', 66, 'Superpower Pokemon', 0.8, 19.5),
  ('Machoke', 67, 'Superpower Pokemon', 1.5, 70.5),
  ('Machamp', 68, 'Superpower Pokemon', 1.5, 70.5),
  ('Bellsprout', 69, 'Flower Pokemon', 0.7, 4.0),
  ('Weepinbell', 70, 'Flycatcher Pokemon', 1.0, 6.4),
  ('Victreebel', 71, 'Flycatcher Pokemon', 1.7, 15.5),
  ('Tentacool', 72, 'Jellyfish Pokemon', 0.9, 45.5),
  ('Tentacruel', 73, 'Jellyfish Pokemon', 1.6, 55.0),
  ('Geodude', 74, 'Rock Pokemon', 0.4, 22.0),
  ('Graveler', 75, 'Rock Pokemon', 1.0, 105.0),
  ('Golem', 76, 'Megaton Pokemon', 1.4, 300.0),
  ('Ponyta', 77, 'Fire Horse Pokemon', 1.0, 30.0),
  ('Rapidash', 78, 'Fire Horse Pokemon', 1.7, 95.0),
  ('Muk', 89, 'Sludge Pokemon', 1.2, 30.0),
  ('Onix', 95, 'Rock Snake Pokemon', 8.8, 210.0),
  ('Voltorb', 100, 'Ball Pokemon', 0.5, 10.4),
  ('Koffing', 109, 'Poison Gas Pokemon', 0.6, 1.0),
  ('Weezing', 110, 'Poison Gas Pokemon', 1.2, 9.5),
  ('Rhyhorn', 111, 'Spikes Pokemon', 1.0, 115.0),
  ('Rhydon', 112, 'Drill Pokemon', 1.9, 120.0),
  ('Tangela', 114, 'Vine Pokemon', 1.0, 35.0),
  ('Staryu', 120, 'Star Shape Pokemon', 0.8, 34.5),
  ('Starmie', 121, 'Mysterious Pokemon', 1.1, 80.0),
  ('Mr. Mime', 122, 'Barrier Pokemon', 1.3, 54.5),
  ('Snorlax', 143, 'Sleeping Pokemon', 2.1, 460.0),
  ('Pichu', 172, 'Tiny Mouse Pokemon', 0.3, 2.0),
  ('Cleffa', 173, 'Star Shape Pokemon', 0.3, 3.0);
  

--Location Inserts--
INSERT INTO Location (LocName, LocType, Region) VALUES
  ('Pallet Town', 'city', 'Kanto'),
  ('Viridian City', 'city', 'Kanto'),
  ('Pewter City', 'city', 'Kanto'),
  ('Cerulean City', 'city', 'Kanto'),
  ('Vermillion City', 'city', 'Kanto'),
  ('Lavender Town', 'city', 'Kanto'),
  ('Celadon City', 'city', 'Kanto'),
  ('Fuchsia City', 'city', 'Kanto'),
  ('Saffron City', 'city', 'Kanto'),
  ('Cinnabar Island', 'city', 'Kanto'),
  ('Route 1', 'grass', 'Kanto'),
  ('Route 2', 'forest', 'Kanto'),
  ('Diglett''s Cave', 'cave', 'Kanto'),
  ('Mt. Moon', 'mountain', 'Kanto'),
  ('Pallet Town', 'city', 'Kanto'),
  ('Route 12', 'lake', 'Kanto'),
  ('Kanto Power Plant', 'building', 'Kanto'),
  ('Silph Co.', 'building', 'Kanto'),
  ('Azalea Town', 'city', 'Johto'),
  ('Goldenrod City', 'city', 'Johto'),
  ('Ecruteak City', 'city', 'Johto'),
  ('Olivine City', 'city', 'Johto'),
  ('Route 19', 'ocean', 'Kanto'),
  ('Route 30', 'grass', 'Johto'),
  ('Ruins of Alph', 'ruins', 'Johto'),
  ('Route 40', 'ocean', 'Johto'),
  ('Route 42', 'lake', 'Johto'),
  ('Ice Path', 'cave', 'Johto'),
  ('Route 104', 'grass', 'Hoenn'),
  ('Route 105', 'ocean', 'Hoenn'),
  ('Route 112', 'volcano', 'Hoenn'),
  ('Route 113', 'ash', 'Hoenn'),
  ('Rustboro City', 'city', 'Hoenn'),
  ('Mauville City', 'city', 'Hoenn'),
  ('Viridian Forest', 'forest','Kanto'),
  ('Lavaridge Town', 'city', 'Hoenn'),
  ('Route 3', 'grass', 'Hoenn');
  
--Type Inserts--
INSERT INTO Type VALUES
  ('Normal'),
  ('Fire'),
  ('Fighting'),
  ('Water'),
  ('Flying'),
  ('Grass'),
  ('Electric'),
  ('Poison'),
  ('Ground'),
  ('Psychic'),
  ('Rock'),
  ('Ice'),
  ('Bug'),
  ('Dragon'),
  ('Ghost'),
  ('Dark'),
  ('Steel'),
  ('Fairy');
  
--Type Weakness Inserts--
INSERT INTO TypeWeakness VALUES
  ('Normal', 'Fighting'),
  ('Fire','Water'),
  ('Fire','Ground'),
  ('Fire','Rock'),
  ('Fighting', 'Psychic'),
  ('Fighting', 'Flying'),
  ('Fighting', 'Fairy'),
  ('Water', 'Grass'),
  ('Water', 'Electric'),
  ('Flying', 'Electric'),
  ('Flying', 'Rock'),
  ('Flying', 'Ice'),
  ('Grass', 'Fire'),
  ('Grass', 'Bug'),
  ('Grass', 'Flying'),
  ('Grass', 'Ice'),
  ('Grass', 'Poison'),
  ('Electric', 'Ground'),
  ('Ground', 'Grass'),
  ('Ground', 'Ice'),
  ('Ground', 'Water'),
  ('Psychic', 'Dark'),
  ('Psychic', 'Ghost'),
  ('Psychic', 'Bug');
  
--Type Strength Inserts--
INSERT INTO TypeStrength VALUES
  ('Fire', 'Grass'),
  ('Fire', 'Bug'),
  ('Fire','Ice'),
  ('Fire','Steel'),
  ('Fighting','Normal'),
  ('Fighting','Dark'),
  ('Fighting','Ice'),
  ('Fighting','Rock'),
  ('Water', 'Fire'),
  ('Water', 'Ground'),
  ('Water', 'Rock'),
  ('Flying', 'Bug'),
  ('Flying', 'Fighting'),
  ('Flying', 'Grass'),
  ('Grass', 'Water'),
  ('Grass', 'Ground'),
  ('Grass', 'Rock'),
  ('Electric', 'Water'),
  ('Electric', 'Flying'),
  ('Poison', 'Grass'),
  ('Poison', 'Fairy'),
  ('Ground', 'Electric'),
  ('Ground', 'Fire'),
  ('Ground', 'Poison'),
  ('Ground', 'Rock'),
  ('Ground', 'Steel');
  
--Type Combo Inserts--
INSERT INTO TypeCombo VALUES
  ('Bulbasaur', 'Grass'),
  ('Bulbasaur', 'Poison'),
  ('Ivysaur', 'Grass'),
  ('Ivysaur', 'Poison'),
  ('Venusaur', 'Grass'),
  ('Venusaur', 'Poison'),
  ('Charmander', 'Fire'),
  ('Charmeleon', 'Fire'),
  ('Charizard', 'Fire'),
  ('Charizard', 'Flying'),
  ('Squirtle', 'Water'),
  ('Wartortle', 'Water'),
  ('Blastoise', 'Water'),
  ('Caterpie', 'Bug'),
  ('Metapod', 'Bug'),
  ('Butterfree', 'Bug'),
  ('Butterfree', 'Flying'),
  ('Weedle', 'Bug'),
  ('Weedle', 'Poison'),
  ('Kakuna', 'Bug'),
  ('Kakuna', 'Poison'),
  ('Beedrill', 'Bug'),
  ('Beedrill', 'Poison'),
  ('Pidgey', 'Normal'),
  ('Pidgey', 'Flying'),
  ('Pidgeotto', 'Normal'),
  ('Pidgeotto', 'Flying'),
  ('Pidgeot', 'Normal'),
  ('Pidgeot', 'Flying'),
  ('Rattata', 'Normal'),
  ('Raticate', 'Normal'),
  ('Spearow', 'Normal'),
  ('Spearow', 'Flying'),
  ('Fearow', 'Normal'),
  ('Fearow', 'Flying');
  
--Inhabitants Inserts--
INSERT INTO Inhabitants VALUES
  (1, 'Squirtle'),
  (1, 'Charmander'),
  (1, 'Bulbasaur'),
  (11, 'Pidgey'),
  (11, 'Rattata'),
  (12, 'Caterpie'),
  (12, 'Weedle'),
  (12, 'Pidgey'),
  (12, 'Rattata'),
  (12, 'Nidoran♀'),
  (12, 'Nidoran♂'),
  (13, 'Diglett'),
  (13, 'Dugtrio'),
  (14, 'Clefairy'),
  (35, 'Pikachu'),
  (35, 'Caterpie'),
  (35, 'Weedle'),
  (35, 'Kakuna'),
  (35, 'Metapod'),
  (35, 'Pidgey'),
  (35, 'Pidgeotto'),
  (37, 'Pidgey'),
  (37, 'Rattata'),
  (37, 'Spearow'),
  (37, 'Sandshrew'),
  (37, 'Jigglypuff'),
  (37, 'Mankey');
  
--Evolution Inserts--
INSERT INTO Evolution VALUES
  ('Squirtle', 'Wartortle', 'Level up'),
  ('Wartortle', 'Blastoise', 'Level up'),
  ('Bulbasaur', 'Ivysaur', 'Level up'),
  ('Ivysaur', 'Venusaur', 'Level up'),
  ('Charmander', 'Charmeleon', 'Level up'),
  ('Charmeleon', 'Charizard', 'Level up'),
  ('Caterpie', 'Metapod', 'Level up'),
  ('Metapod', 'Butterfree', 'Level up'),
  ('Weedle', 'Kakuna', 'Level up'),
  ('Kakuna', 'Beedrill', 'Level up'),
  ('Pidgey', 'Pidgeotto', 'Level up'),
  ('Pidgeotto', 'Pidgeot', 'Level up'),
  ('Rattata', 'Raticate', 'Level up'),
  ('Spearow', 'Fearow', 'Level up'),
  ('Ekans', 'Arbok', 'Level up'),
  ('Pichu', 'Pikachu', 'Happiness'),
  ('Pikachu', 'Raichu', 'Level up'),
  ('Sandshrew', 'Sandslash', 'Level up'),
  ('Nidoran♀', 'Nidorina', 'Level up'),
  ('Nidorina', 'Nidoqueen', 'Item'),
  ('Nidoran♂', 'Nidorino', 'Level up'),
  ('Nidorino', 'Nidoking', 'Item'),
  ('Cleffa', 'Clefairy', 'Happiness'),
  ('Clefairy', 'Clefable', 'Item');
  
--Move Inserts--
INSERT INTO Move VALUES
    ('Pound', 'Normal', 35, 40, 100),
    ('Karate Chop', 'Fighting', 25, 50, 100),
    ('Double Slap', 'Normal', 10, 15, 85),
    ('Comet Punch', 'Normal', 15, 18, 85),
    ('Swords Dance', 'Normal', 20, null, null),
    ('Fire Punch', 'Fire', 20, 75, 100),
    ('Ice Punch', 'Ice', 20, 75, 100),
    ('Thunder Punch', 'Electric', 20, 75, 100),
    ('Scratch', 'Normal', 35, 40, 100),
    ('Gust', 'Flying', 35, 40, 100),
    ('Wing Attack', 'Flying', 35, 60, 100),
    ('Fly', 'Flying', 35, 90, 95),
    ('Vine Whip', 'Grass', 20, 45, 100),
    ('Double Kick', 'Fighting', 30, 30, 100),
    ('Jump Kick', 'Fighting', 10, 100, 95),
    ('Sand Attack', 'Ground', 15, null, 100),
    ('Tackle', 'Normal', 35, 50, 100),
    ('Take Down', 'Normal', 20, 90, 85),
    ('Harden', 'Normal', 35, null, null),
    ('Poison Sting', 'Poison', 35, 15, 100),
    ('Twineedle', 'Bug', 20, 25, 100),
    ('Pin Missle', 'Fire', 20, 25, 95),
    ('Leer', 'Normal', 30, null, 100),
    ('Bite', 'Dark', 25, 60, 100),
    ('Acid', 'Poison', 30, 40, 100),
    ('Ember', 'Fire', 25, 40, 100),
    ('Flamethrower', 'Fire', 15, 90, 100),
    ('Mist', 'Ice', 30, null, null),
    ('Ice Beam', 'Ice', 10, 90, 100),
    ('Blizzard', 'Ice', 5, 110, 70),
    ('Water Gun', 'Water', 25, 40, 100),
    ('Hydro Pump', 'Water', 5, 110, 80),
    ('Surf', 'Water', 15, 90, 100),
    ('Psybeam', 'Psychic', 20, 65, 100),
    ('Hyperbeam', 'Normal', 5, 150, 90),
    ('Peck', 'Flying', 35, 35, 100),
    ('Strength', 'Normal', 15, 80, 100),
    ('Absorb', 'Grass', 25, 20, 100),
    ('Mega Drain', 'Fire', 15, 40, 100),
    ('Razor Leaf', 'Grass', 20, 75, 100),
    ('Dragon Rage', 'Dragon', 10, null, 100),
    ('Thunder Shock', 'Electric', 30, 40, 100),
    ('Thunderbolt', 'Electric', 15, 90, 100),
    ('Rock Throw', 'Rock', 15, 50, 90),
    ('Rock Slide', 'Rock', 10, 75, 90),
    ('Earthquake', 'Ground', 10, 100, 100),
    ('Fissure', 'Ground', 5, null, 30),
    ('Toxic', 'Poison', 10, null, 90),
    ('Confusion', 'Psychic', 25, 50, 100),
    ('Psychic', 'Psychic', 25, 90, 100),
    ('Disarming Voice', 'Fairy', 15, 40, null),
    ('Moonblast', 'Fairy', 15, 95, 100),
    ('Heavy Slam', 'Steel', 10, null, 100);
    
 --Moveset Inserts--
 INSERT INTO Moveset VALUES
   ('Venusaur', 'Tackle', 'Level up'),
   ('Venusaur', 'Vine Whip', 'Starts with'),
   ('Charizard', 'Scratch', 'Starts with'),
   ('Charizard', 'Ember', 'Level up'),
   ('Blastoise', 'Tackle', 'Starts with'),
   ('Blastoise', 'Water Gun', 'Level up'),
   ('Blastoise', 'Bite', 'Level up'),
   ('Blastoise', 'Hydro Pump', 'Level up'),
   ('Blastoise', 'Surf', 'TM/HM'),
   ('Caterpie', 'Tackle', 'Starts with'),
   ('Metapod', 'Harden', 'Starts with'),
   ('Butterfree', 'Confusion', 'Starts with'),
   ('Butterfree', 'Gust', 'Level up'),
   ('Butterfree', 'Psybeam', 'Level up'),
   ('Pidgeot', 'Gust', 'Starts with'),
   ('Pidgeot', 'Sand Attack', 'Starts with'),
   ('Pidgeot', 'Wing Attack', 'Level up'),
   ('Pidgeot', 'Take Down', 'TM/HM'),
   ('Pidgeot', 'Fly', 'TM/HM'),
   ('Arbok', 'Leer', 'Starts with'),
   ('Arbok', 'Poison Sting', 'Starts with'),
   ('Arbok', 'Bite', 'Level up'),
   ('Arbok', 'Acid', 'Level up'),
   ('Arbok', 'Toxic', 'TM/HM'),
   ('Clefairy', 'Pound', 'Starts with'),
   ('Clefairy', 'Double Slap', 'Level up'),
   ('Clefairy', 'Disarming Voice', 'Level up'),
   ('Clefairy', 'Moonblast', 'Starts with'),
   ('Golem', 'Heavy Slam', 'Level up'),
   ('Snorlax', 'Heavy Slam', 'Level up'),
   ('Machop', 'Heavy Slam', 'Level up'),
   ('Machoke', 'Heavy Slam', 'Level up'),
   ('Machamp', 'Heavy Slam', 'Level up'),
   ('Onix', 'Heavy Slam', 'Level up');
   
 --Gym Leader Inserts--
 INSERT INTO GymLeader VALUES
   ('Brock', 'Rock', 3, 'Boulder Badge'),
   ('Misty', 'Water', 4, 'Cascade Badge'),
   ('Lt. Surge', 'Electric', 5, 'Thunder Badge'),
   ('Erika', 'Grass', 7, 'Rainbow Badge'),
   ('Koga', 'Poison', 8, 'Soul Badge'),
   ('Sabrina', 'Psychic', 9, 'Marsh Badge'),
   ('Blaine', 'Fire', 10, 'Volcano Badge'),
   ('Giovanni', 'Ground', 2, 'Earth Badge'),
   ('Bugsy', 'Bug', 19, 'Hive Badge'),
   ('Whitney', 'Normal', 20, 'Plain Badge'),
   ('Morty', 'Ghost', 21, 'Fog Badge'),
   ('Jasmine', 'Steel', 22, 'Mineral Badge'),
   ('Roxanne', 'Rock', 33, 'Stone Badge'),
   ('Wattson', 'Electric', 34, 'Dynamo Badge'),
   ('Flannery', 'Fire', 36, 'Heat Badge');
   
 --Team Inserts--
INSERT INTO Team VALUES
   ('Brock', 'Geodude'),
   ('Brock', 'Onix'),
   ('Misty', 'Staryu'),
   ('Misty', 'Starmie'),
   ('Lt. Surge', 'Voltorb'),
   ('Lt. Surge', 'Pikachu'),
   ('Lt. Surge', 'Raichu'),
   ('Erika', 'Victreebel'),
   ('Erika', 'Tangela'),
   ('Erika', 'Vileplume'),
   ('Koga', 'Koffing'),
   ('Koga', 'Weezing'),
   ('Koga', 'Muk'),
   ('Sabrina', 'Kadabra'),
   ('Sabrina', 'Mr. Mime'),
   ('Sabrina', 'Venomoth'),
   ('Sabrina', 'Alakazam'),
   ('Blaine', 'Growlithe'),
   ('Blaine', 'Ponyta'),
   ('Blaine', 'Rapidash'),
   ('Blaine', 'Arcanine'),
   ('Giovanni', 'Rhyhorn'),
   ('Giovanni', 'Dugtrio'),
   ('Giovanni', 'Nidoqueen'),
   ('Giovanni', 'Nidoking'),
   ('Giovanni', 'Rhydon');

 --Gym Leader Locations View--  
CREATE VIEW GymLeaderLocations AS
  SELECT Location.LocName,
  GymLeader.LeaderName,
  GymLeader.TypeName
  FROM GymLeader
  INNER JOIN Location
  ON GymLeader.LocID = Location.LocID;

--Gym Leader Weakness View--
CREATE VIEW GymLeaderWeakness AS
  Select GymLeader.LeaderName,
  GymLeader.TypeName,
  TypeWeakness.TypeWeakness
  FROM GymLeader
  INNER JOIN TypeWeakness
  ON GymLeader.TypeName = TypeWeakness.TypeName
  ORDER BY LeaderName ASC;
  
--Pokemon Locations--
CREATE VIEW PokemonLocations AS
  SELECT Inhabitants.PokemonName,
  Location.LocName,
  Location.Region
  FROM Inhabitants
  INNER JOIN Location
  ON Inhabitants.LocID = Location.LocID;
  
--Strongest Type Report--  
SELECT TypeName,
COUNT(TypeName) AS TypeOccurence
FROM TypeStrength
GROUP BY TypeName
ORDER BY TypeOccurence
LIMIT 1;

--Trainer Role Creation--
CREATE ROLE Trainer;
GRANT SELECT ON 
Pokemon, Evolution,
Inhabitants, Location,
Team, GymLeader,
Move, Moveset,
Type, TypeCombo,
TypeStrength, TypeWeakness
TO Trainer;

CREATE USER Red;
CREATE USER Blue;
CREATE USER Joey;
GRANT Trainer TO Red, Blue;

--Leader Role Creation--
CREATE ROLE Leader;
GRANT SELECT ON 
Pokemon, Evolution,
Inhabitants, Location,
Team, GymLeader,
Move, Moveset,
Type, TypeCombo,
TypeStrength, TypeWeakness
TO Leader;
GRANT UPDATE ON
GymLeader
TO Leader;
GRANT INSERT, UPDATE ON
Team
TO Leader;

CREATE USER Brock;
CREATE USER Misty;
CREATE USER Surge;
GRANT Leader TO Brock, Misty, Surge;

--Administrator Role Creation-- 
DROP ROLE IF EXISTS Administrator;
CREATE ROLE Administrator;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO Administrator;

CREATE USER ProfessorOak;
CREATE USER ProfessorElm;
CREATE USER Bill;
GRANT Administrator TO ProfessorOak, ProfessorElm, Bill;

--Stored procedure--
CREATE OR REPLACE FUNCTION get_moves_by_prior_evolution(text, REFCURSOR) RETURNS REFCURSOR AS
$$
DECLARE 
    evo text := $1;
    resultset REFCURSOR := $2;
BEGIN 
    open resultset FOR
        SELECT MoveName 
        FROM Moveset
        WHERE PokemonName in (
            SELECT PokemonName
            FROM Evolution
            WHERE EvolutionName = evo)
        UNION
        SELECT MoveName 
        FROM Moveset
        WHERE PokemonName IN (
            SELECT PokemonName
            FROM Evolution
            WHERE EvolutionName IN (
                SELECT PokemonName
                FROM Evolution
                WHERE EvolutionName = evo));
    RETURN resultset;
END;
$$
Language plpgsql;