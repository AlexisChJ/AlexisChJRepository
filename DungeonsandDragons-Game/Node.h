#ifndef NODE_H
#define NODE_H
template <typename T>

class Node {
private:
  Node *next;
  T data;

public:
  Node(T data);
  T getData();
  void setData(T data);
  void setNext(Node *next);
  Node *getNext();
  void print();
};
#endif