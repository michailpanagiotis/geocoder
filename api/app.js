const Koa = require('koa');
const app = new Koa();
var elasticsearch = require('elasticsearch');
var client = new elasticsearch.Client({
  host: 'elasticsearch:9200',
  log: 'trace'
});

app.use(ctx => {
  const lat = 37.842229;
  const lon = 22.505088;
  return client.search({
    index: 'kalapokd',
    body: {
      query: {
        bool: {
          must: {
            match_all: {}
          },
          filter: {
              geo_shape: {
                geometry: {
                    shape: {
                      type: "point",
                      coordinates : [lon, lat]
                    },
                    relation: "contains"
                }
              }
          }
        }
      }
    }
  }).then((body) => {
    ctx.body = body;
  });
});

app.listen(3000);
