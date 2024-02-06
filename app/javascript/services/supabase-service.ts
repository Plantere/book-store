import { createClient } from '@supabase/supabase-js'

const supabase = createClient(import.meta.env.VITE_PUBLIC_SUPABASE_URL, import.meta.env.VITE_PUBLIC_SUPABASE_KEY)

export const storeImage = async (path: string, fileBody: File) => {
  const uuidImage = crypto.randomUUID()

  await supabase
    .storage
    .from('books')
    .upload(`${path}/${uuidImage}.png`, fileBody, {
      cacheControl: '3600',
      upsert: false
    })

  return uuidImage
}

export const getImages = (imagePaths: string[]): string[] => {
  let imageLinks: string[] = []

  imagePaths.forEach(path => {
    imageLinks.push(supabase.storage.from('books').getPublicUrl(path).data.publicUrl)
  }) 
  
  return imageLinks
}

export const getImage = (imagePath: string | undefined): string => {
  if(imagePath === undefined || !imagePath.length) return "https://placehold.co/990x1500"
  return supabase.storage.from('books').getPublicUrl(imagePath).data.publicUrl
}