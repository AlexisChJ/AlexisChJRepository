#include "Player.h"
#include "Monster.h"
Player::Player() {
  this->name = "";
  this->raza = "";
  hp=10;
  lp=100;
}

Player::Player(string name, string raza){
  this->name=name;
  this->raza=raza;
  hp=10;
  lp=100;
}
string Player::getName(){
  return name;}
void Player::setName(string name){
  this->name=name;}
int Player::getHp(){
  return hp;}
void Player::setHp(int hp){
  this->hp=hp;}
string Player::getRaza(){
  return raza;}
void Player::setRaza(string raza){
  this->raza=raza;}
int Player::getLp(){
  return lp;}
void Player::setLp(int lp){
  this->lp=lp;}
void Player::attack(Player player, Monster& monster){
  int nuevoLp = monster.getHitPoints() - player.getHp();
  monster.setHitPoints(nuevoLp);
  
}