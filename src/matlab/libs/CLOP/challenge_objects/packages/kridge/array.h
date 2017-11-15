#ifndef _STACK_H_
#define _STACK_H_


#include <stdlib.h>
#include <memory.h>
#include "mmm.h"

template<class T> class v_array{
 
private:
  
public:
  int index;
  int length;
  T* elements;

  int size(){return index;};
  T& last() { return elements[index-1];}
  void decr() { index--;}
  v_array() { index = 0; length=0; elements = NULL;}
  T& operator[](unsigned int i) { return elements[i]; }

//  v_array & operator = (const v_array<T> & m);
  void clear() { FREE(elements); index=0;length=0;elements=NULL;};
};

template<class T> 
void remove(v_array<T> & v,int k)
{
	v[k]=last(v);
	v.index--;
}



template<class T> 
v_array<T> clone(const v_array<T> & m)
{
	v_array<T> t;
	t.index=m.index;
	t.length=m.length;
	t.elements=(T*)MALLOC(sizeof(T)*t.length);
	memcpy(t.elements,m.elements,sizeof(T)*t.length);
	return t;
}

template<class T> void push(v_array<T>& v, const T &new_ele)
{
  while(v.index >= v.length)
    {
	  T*temp;
	  int oldlength=v.length;
      v.length = 2*v.length + 3;
      temp= (T *)MALLOC(sizeof(T) * v.length);
	  memcpy(temp,v.elements,sizeof(T) * oldlength);
	  FREE(v.elements);
	  v.elements=temp;
    }
  v[v.index++] = new_ele;
}



template<class T> void alloc(v_array<T>& v, int length)
{
	if(length>v.length)
	{
		T*temp = (T*)MALLOC(sizeof(T) * length);
		if(v.elements)
		{
			memcpy(temp,v.elements,sizeof(T)*v.length);
			FREE(v.elements);
		}
		v.elements=temp;
	}
	v.length = length;
	
}

template<class T> v_array<T> pop(v_array<v_array<T> > &stack)
{
  if (stack.index > 0)
    return stack[--stack.index];
  else
    return v_array<T>();
}


#endif