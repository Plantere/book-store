export const formatMoney = (money: number | string):string => {
  if(typeof money === "string"){
    money = parseFloat(money)
  }

  return money.toLocaleString('en-US', {
    style: 'currency',
    currency: 'USD',
  });
}

export const convertStringToNumber = (price: number | string): number => {
  if(typeof price === "number")
    return price
  return parseFloat(price)
}