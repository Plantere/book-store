import { defineStore } from 'pinia';

interface Product {
  productId: number;
  quantity: number;
}

const STORE_NAME = 'cart'

const getCart = (): Product[] => {
  const cart = localStorage.getItem(STORE_NAME)
  return cart ? JSON.parse(cart) : []
}

const storeLocalStorage = (cartList: Product[]): void => {
  localStorage.setItem(STORE_NAME, JSON.stringify(cartList))
}

export const useCartStore = defineStore(STORE_NAME, {
  state: () => ({
    cartList: getCart(),
  }),
  actions: {
    addProduct(productId: number): void {
      let product = this.cartList.find((product: Product) => product.productId === productId)

      if(!product){
        this.cartList.push({
          productId: productId,
          quantity: 1,
        })
      }else{
        product.quantity += 1;
      }

      storeLocalStorage(this.cartList)
    },
    removeProduct(productId: number): void {
      this.cartList = this.cartList.filter((product: Product) => product.productId !== productId)
      storeLocalStorage(this.cartList)
    },
    decreaseProduct(productId: number): void {
      let product = this.cartList.find((product: Product) => product.productId === productId)
      
      if(!product){
        return
      }
      
      if(product.quantity <= 1) {
        this.removeProduct(productId)
      } else {
        product.quantity -= 1;
      }

      storeLocalStorage(this.cartList)
    },
    isAvailable(productId: number, stockQuantity: number) {
      let product = this.cartList.find((product: Product) => product.productId === productId)
      
      if(!product){
        return false
      }

      return product.quantity >= stockQuantity
    }
  },
});
