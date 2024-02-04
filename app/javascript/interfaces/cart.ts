export interface ICart {
  id: number;
  name: string;
  image: string;
  price: number;
  cart_quantity: number;
  stock_quantity: number;
}

export interface IItemsCart {
  cart: ICart[]
}

export interface IItemCart {
  cart: ICart
}