@val external document: {..} = "document"
@val external window: {..} = "window"

module Post = {
  type t = {
    title: string,
    author: string,
    text: array<string>,
  }

  let make = (~title, ~author, ~text) => {title: title, author: author, text: text}
  let title = t => t.title
  let author = t => t.author
  let text = t => t.text
}

let posts = [
  Post.make(
    ~title="The Razor's Edge",
    ~author="W. Somerset Maugham",
    ~text=[
      "\"I couldn't go back now. I'm on the threshold. I see vast lands of the spirit stretching out before me,
    beckoning, and I'm eager to travel them.\"",
      "\"What do you expect to find in them?\"",
      "\"The answers to my questions. I want to make up my mind whether God is or God is not. I want to find out why
    evil exists. I want to know whether I have an immortal soul or whether when I die it's the end.\"",
    ],
  ),
  Post.make(
    ~title="Ship of Destiny",
    ~author="Robin Hobb",
    ~text=[
      "He suddenly recalled a callow boy telling his tutor that he dreaded the sea voyage home, because he would have
        to be among common men rather than thoughtful acolytes like himself. What had he said to Berandol?",
      "\"Good enough men, but not like us.\"",
      "Then, he had despised the sort of life where simply getting from day to day prevented a man from ever taking
        stock of himself. Berandol had hinted to him then that a time out in the world might change his image of folk
        who labored every day for their bread. Had it? Or had it changed his image of acolytes who spent so much time in
        self-examination that they never truly experienced life?",
    ],
  ),
  Post.make(
    ~title="A Guide for the Perplexed: Conversations with Paul Cronin",
    ~author="Werner Herzog",
    ~text=[
      "Our culture today, especially television, infantilises us. The indignity of it kills our imagination. May I propose a Herzog dictum? Those who read own the world. Those who watch television lose it. Sitting at home on your own, in front of the screen, is a very different experience from being in the communal spaces of the world, those centres of collective dreaming. Television creates loneliness. This is why sitcoms have added laughter tracks which try to cheat you out of your solitude. Television is a reflection of the world in which we live, designed to appeal to the lowest common denominator. It kills spontaneous imagination and destroys our ability to entertain ourselves, painfully erasing our patience and sensitivity to significant detail.",
    ],
  ),
]

let getPostText = (text) => {
  `<p class="post-text">${text}</p>`
}

let getPostDescription = (arr) => {
  let postText = Belt.Array.map(arr, x => getPostText(x))
  Js.Array.joinWith("\n", postText)
}

let createPost = (index, x) => {
  let i = Belt.Int.toString(index)
  `<h2 class="post-heading">${x->Post.title}</h2>
    <h3>${x->Post.author}</h3>
    ${getPostDescription(x->Post.text)}
    <button id="block-delete-${i}" class="button button-danger">
      Remove this post
    </button>`
}


let deletePost = (post, delBlk, timer_id) => {
  window["clearTimeout"](timer_id) -> ignore
  document["body"]["removeChild"](post) -> ignore
  document["body"]["removeChild"](delBlk)
}

let autoDelete = (post, delBlk) => {
  document["body"]["removeChild"](post) -> ignore
  document["body"]["removeChild"](delBlk)
}

let restorePost = (post, delBlk, timer_id) => {
  window["clearTimeout"](timer_id) -> ignore
  post["style"]["display"] = "block"
  document["body"]["removeChild"](delBlk)
}

let deleteDiv = (post, id) => {
  let parentDiv = document["createElement"]("div")
  parentDiv["id"] = `delete-block-${id}`

  parentDiv["innerHTML"] =
      `<div class="post-deleted pt-1">
      <p class="text-center">
        This post from <em>${post["children"][0]["innerText"]} by ${post["children"][1]["innerText"]}</em> will be
        permanently removed in 10 seconds.
      </p>
      <div class="flex-center">
        <button id="block-restore-${id}" class="button button-warning mr-1">
          Restore
        </button>
        <button id="block-delete-immediate-${id}" class="button button-danger">
          Delete Immediately
        </button>
      </div>
      <div class="post-deleted-progress"></div>
    </div>`
  parentDiv
}


let removeChild = (post, id) => {
  let deleteBlk = deleteDiv(post, id)
  document["body"]["insertBefore"](deleteBlk, post) -> ignore

  let restoreBtn = document["getElementById"](`block-restore-${id}`)
  let delBtn = document["getElementById"](`block-delete-immediate-${id}`)
  post["style"]["display"] = "none"

  let timer_id = window["setTimeout"](() => autoDelete(post, deleteBlk), 10000)
  delBtn["addEventListener"]("click",() => deletePost(post, deleteBlk, timer_id)) -> ignore
  restoreBtn["addEventListener"]("click",() => restorePost(post, deleteBlk, timer_id))
}

Belt.Array.forEachWithIndex(posts, (index, x) => {

  let i = Belt.Int.toString(index)
  let post = document["createElement"]("div")
  post["id"] = `block-${i}`
  post["className"] = "post"
  post["innerHTML"] = createPost(index, x)

  document["body"]["insertBefore"](post, None) -> ignore

  let removeBtn = document["getElementById"](`block-delete-${i}`)
    removeBtn["addEventListener"]("click",() => removeChild(post, i))
  }
)
