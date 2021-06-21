class PokemonDetailed {
  late String id,
      name,
      smallPicture,
      bigPicture,
      evolvesFrom,
      level,
      hp,
      number,
      artist,
      rarity;
  late List<String> subTypes, types, retreatCost;

  PokemonDetailed(json) {
    this.id = json['id'];
    this.name = json['name'];
    this.smallPicture = json['smallPicture'];
    this.bigPicture = json['bigPicture'];
    this.evolvesFrom = json['evolvesFrom'];
    this.level = json['level'];
    this.hp = json['hp'];
    this.number = json['number'];
    this.artist = json['artist'];
    this.rarity = json['rarity'];
    this.subTypes = json['subTypes'];
    this.types = json['types'];
  }
}
      
  //modeles a creer : abilities, attacks, weekness, ressistances, tcgplayer

