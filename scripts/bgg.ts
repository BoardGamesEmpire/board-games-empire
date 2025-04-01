import { BggClient } from 'boardgamegeekclient';
import console from 'node:console'

const client = BggClient.Create();

// const [response] = await client.search.query({
//     query: 'Catan',
//     type: 'boardgame',
// });

// response.items.forEach((item) => {
//   console.log(JSON.stringify(item, null, 2))
// });

async function main() {
  client.family.query({
    id: 2,
  }).then((response) => {
    console.log(JSON.stringify(response, null, 2))
  });

  // const [response] = await client.thing.query({
  //   id: [13, 822],
  //   type: 'boardgame',
  // })

  // console.log(JSON.stringify(response, null, 2))

}

main().catch((error) => {
  console.error('Error:', error);
})
