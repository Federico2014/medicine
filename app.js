import createError from 'http-errors'
import express from 'express'
import path from 'path'
import cookieParser from 'cookie-parser'
import logger from 'morgan'
import bodyParser from 'body-parser'
import SourceMapSupport from 'source-map-support'

// define our app using express
const app = express();

// import router
import indexRouter from './routes/routes_index'
import apiRouter from './routes/routes_api'

// view engine setup
app.set('views', path.join(__dirname, 'App/views'))
app.set('view engine', 'ejs');

app.use(logger('dev'));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

/*
 *	Using database config
 */
//  import databaseConfig from './config/mongodb';
//  databaseConfig();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.use('/'     , indexRouter)
   .use('/api'  , apiRouter)

// add Source Map Support
SourceMapSupport.install();

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};
  if(err.message == 'Not Found'){
    res.render('404')
  }

  // render the error page
  // res.status(err.status || 500);
  // res.render('error');
});

// allow-cors
app.use(function(req,res,next){
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
})

module.exports = app;
