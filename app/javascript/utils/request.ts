interface OptionsFetch {
  method: string
  data?: Object
}

export const makeRequest = async (path: string, optionsFetch: OptionsFetch) => {
  return await fetch(path, {
    method: optionsFetch.method,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(optionsFetch.data)
  })
}