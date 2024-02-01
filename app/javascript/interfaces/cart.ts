export interface Cart {
  id: number;
  name: string;
  image: string;
  price: number;
  cart_quantity: number;
  stock_quantity: number;
}

export interface ItemsCart {
  cart: Cart[]
}

export interface ItemCart {
  cart: Cart
}