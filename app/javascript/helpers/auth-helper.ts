export function loginUser(token: string){
  let dtm = new Date()
  dtm.setTime(dtm.getTime() + 1 * 24 * 60 * 60 * 1000)
  
  let expires = `expires=${dtm.toUTCString()}`
  document.cookie = `token=${token};${expires};SameSite=Strict`
}

export function hasTokenCookie() {
  const cookieArray = document.cookie.split(";").map(item => item.trim().split("="));
  return !!cookieArray.find(cookie => cookie[0] === "token");
}

export function removeTokenCookie(){
  document.cookie = "token" + '=;expires=Thu, 01 Jan 1970 00:00:01 GMT;SameSite=Strict;'; 
}