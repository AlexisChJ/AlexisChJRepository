#include "Node.h"
#include "Monster.h"
#include "Calabozo.h"
#include <iostream>
using namespace std;

template <typename T> Node<T>::Node(T data) {
  this->data = data;
  this->next = nullptr;
}
template <typename T> void Node<T>::setData(T data) { this->data = data; }
template <typename T> T Node<T>::getData() { return data; }
template <typename T> Node<T> *Node<T>::getNext() { return next; }
template <typename T> void Node<T>::setNext(Node<T> *next) {
  this->next = next;}
template <typename T> void Node<T>::print() { cout << "[" << data << "] "; }
template class Node<Monster>;
template class Node<Calabozo>;