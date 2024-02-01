import type { Address } from './address'

export interface Order {
  id: number;
  status: number;
  created_at: string;
  address: Address;
  description: string;
  price: number;
  details: OrderDetail[];
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