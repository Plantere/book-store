import type { Address } from './address'

export interface Order {
  id: number;
  status: number;
  address: Address;
  user?: User;
  description: string;
  price: number | string;
  details: OrderDetail[];
  created_at: string;
}

export interface User {
  first_name: string,
  last_name: string,
  email: string,
}

export interface OrderDetail {
  id: number
  name: string
  image?: string
  quantity: number
  price: number
}

export interface OrderItem {
  order: Order
}