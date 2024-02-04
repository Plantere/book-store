import type { IAddress } from './address'

export interface IOrder {
  id: number;
  status: number;
  address: IAddress;
  user?: IUser;
  description: string;
  price: number | string;
  details: IOrderDetail[];
  created_at: string;
}

export interface IUser {
  first_name: string,
  last_name: string,
  email: string,
}

export interface IOrderDetail {
  id: number
  name: string
  image?: string
  quantity: number
  price: number
}

export interface IOrderItem {
  order: IOrder
}