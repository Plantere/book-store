export interface Address {
  name: string,
  id: number,
  is_default: boolean,
  postal_code: string,
  number: string,
  city: string,
  state: string,
  street: string,
  district: string,
  country: string,
  phone_number: string,
}

export interface ItemsAddress {
  address: Address
}