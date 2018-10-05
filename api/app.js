const Koa = require('koa');
const Router = require('koa-router');
const elasticsearch = require('elasticsearch');
const querystring = require('querystring');

const app = new Koa();
const router = new Router();
const client = new elasticsearch.Client({
  host: 'elasticsearch:9200',
  // log: 'trace'
});

const sets = {
  kaldimen: 'ΔΗΜΟΤΙΚΕΣ ΕΝΟΤΗΤΕΣ ΚΑΛΛΙΚΡΑΤΗ',
  kaldim: 'ΔΗΜΟΙ ΚΑΛΛΙΚΡΑΤΗ',
  kalperen: 'ΠΕΡΙΦΕΡΕΙΑΚΕΣ ΕΝΟΤΗΤΕΣ ΚΑΛΛΙΚΡΑΤΗ',
  kalper: 'ΠΕΡΙΦΕΡΕΙΕΣ ΚΑΛΛΙΚΡΑΤΗ',
  kalapokd: 'ΑΠΟΚΕΝΤΡΩΜΕΝΕΣ ΔΙΟΙΚΗΣΕΙΣ ΚΑΛΛΙΚΡΑΤΗ',
  kalgeoen: 'ΜΕΓΑΛΕΣ ΓΕΩΓΡΑΦΙΚΕΣ ΕΝΟΤΗΤΕΣ ΚΑΛΛΙΚΡΑΤΗ',
};

const hierarchy = ['kaldimen', 'kaldim', 'kalperen', 'kalper', 'kalapokd', 'kalgeoen'];

router.get('/reverse/', async ctx => {
  try {
    if (!ctx.query.latlon) {
      throw new Error('\'latlon\' query parameter missing on request')
    }
    const [lat, lon] = ctx.query.latlon.split(',').map(c => parseFloat(c));
    await client.ping();
    const result = await client.search({
      index: 'combined',
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
    });
    const body = [];
    result.hits.hits.forEach(h => {
      const { _source, _id } = h;
      body.push({ ..._source.properties, ID: _id, TYPE: _source.ktype, TYPE_DESC: sets[_source.ktype] });
    });
    ctx.set('Content-Type', 'application/json');
    ctx.body = body.sort((a, b) => {
      const aIndex = hierarchy.findIndex(x => a.TYPE === x);
      const bIndex = hierarchy.findIndex(x => b.TYPE === x);
      return aIndex - bIndex;
    });
  } catch (e) {
    ctx.status = 400;
    ctx.body = e.message;
  }
});

app
  .use(router.routes())
  .use(router.allowedMethods());

app.listen(3000);
