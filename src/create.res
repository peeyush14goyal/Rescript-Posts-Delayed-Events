let getPara = (text) => {
  `<p class="post-text">${text}</p>`
}

let getDescription = (arr) => {
  let postText = Belt.Array.map(arr, x => getPara(x))
  Js.Array.joinWith("\n", postText)
}

let createPost = (x, index) => {
  let i = Belt.Int.toString(index)

  `<div id="block-${i}" class="post">
      <h2 class="post-heading">${x->PostMod.Post.title}</h2>
      <h3>${x->PostMod.Post.author}</h3>
      ${getDescription(x->PostMod.Post.text)}
      <button id="block-delete-${i}" class="button button-danger">
        Remove this post
      </button>
   </div>`
}
