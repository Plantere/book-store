import { defineStore } from 'pinia';
import { useNotificationStore } from './notification'

interface Book {
  book_id: number;
  quantity: number;
}

const STORE_NAME = 'cart'

const getCart = (): Book[] => {
  const cart = localStorage.getItem(STORE_NAME)
  return cart ? JSON.parse(cart) : []
}

const storeLocalStorage = (cartList: Book[]): void => {
  localStorage.setItem(STORE_NAME, JSON.stringify(cartList))
}

const notifications = useNotificationStore()

export const useCartStore = defineStore(STORE_NAME, {
  state: () => ({
    cartList: getCart(),
  }),
  getters: {
    getTotalCart(){
      return this.cartList.reduce((acc, cart) => {
        return acc + cart.quantity
      }, 0)
    },
    getTotalItems(){
      return this.cartList.length
    }
  },
  actions: {
    addBook(bookId: number): void {
      let book = this.cartList.find((book: Book) => book.book_id === bookId)

      if (!book) {
        this.cartList.push({
          book_id: bookId,
          quantity: 1,
        });
      } else {
        book.quantity += 1;
      }

      storeLocalStorage(this.cartList);
      notifications.createNotification("Book added to the cart successfully", "success");
    },
    removeBook(bookId: number): void {
      this.cartList = this.cartList.filter((book: Book) => book.book_id !== bookId);
      storeLocalStorage(this.cartList);
      notifications.createNotification("Book removed from the cart successfully", "success");
    },
    changeQuantity(bookId: number, quantity: number): void {
      let book = this.cartList.find((book: Book) => book.book_id === bookId);

      if (!book) {
        return;
      }

      book.quantity = quantity
      storeLocalStorage(this.cartList);
    },
    isAvailable(bookId: number, stockQuantity: number) {
      let book = this.cartList.find((book: Book) => book.book_id === bookId);

      if (!book) {
        return false;
      }

      return book.quantity >= stockQuantity;
    },
  },
});