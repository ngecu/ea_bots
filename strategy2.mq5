//+------------------------------------------------------------------+
//|                                                    strategy2.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#define  FIBO_OBJ = "Fibo Retracement";

#property copyright "Copyright 2023, DevNgecu Ltd."
#property link      "https://www.devngecu.com"
#property version   "1.00"

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh> ;
CTrade trade;


int totalBars;
input bool IsHammer = true;
input bool IsEngulfing = true;
input bool IsStar = true;
input double Lots = 0.01;
input int TpPoints = 100;
input int SlPoints = 50;

const string TelegramBotToken = "5309254880:AAE1vJJzNVoqWZ3UAzeOIoqM4Jo7Wg5CrJo";
const string ChatId           = "-1001946807232";
const string TelegramApiUrl   = "https://api.telegram.org"; // Add this to Allow URLs



int EMA25Handle;
int EMA50Handle;
int EMA100Handle;
int EMA200Handle;
int MACDHandle;
int StochHandle;

int EMA25Period=25;
int EMA50Period=50;
int EMA100Period=100;
int EMA200Period=200;

double EMA25Buffer[];
double EMA50Buffer[];
double EMA100Buffer[];
double EMA200Buffer[];
double MACDBuffer[];
double signalBuffer[];
double StochBuffer[];

bool hasCrossedBelow = false;
bool hasCrossedAbove = true;



const int    UrlDefinedError  = 4014; // Because MT4 and MT5 are different
input color           InpColor=clrBlack;
int OnInit()
  {
//---

   EMA25Handle = iMA(_Symbol,PERIOD_CURRENT,EMA25Period,0,MODE_EMA,PRICE_CLOSE);
   EMA50Handle = iMA(_Symbol,PERIOD_CURRENT,EMA50Period,0,MODE_EMA,PRICE_CLOSE);
   EMA100Handle = iMA(_Symbol,PERIOD_CURRENT,EMA100Period,0,MODE_EMA,PRICE_CLOSE);
   EMA200Handle = iMA(_Symbol,PERIOD_CURRENT,EMA200Period,0,MODE_EMA,PRICE_CLOSE);
   MACDHandle = iMACD(_Symbol,PERIOD_CURRENT,12,26,9,PRICE_CLOSE);
   StochHandle = iStochastic(_Symbol,PERIOD_CURRENT,5,3,3,MODE_SMA,STO_LOWHIGH);

   string timeframe = EnumToString(Period());
 string image_url = "https://thriftyniftymommy.com/wp-content/uploads/2019/04/Funny-Good-Morning-Meme-19.jpg";
   string message="Good morning, forex traders! Remember, risk management is key to success. Stay focused, stay resilient, and keep believing in yourself. Happy trading!";
   
   SendTelegramMessage(TelegramApiUrl, TelegramBotToken, ChatId, message);


totalBars = iBars(_Symbol,PERIOD_CURRENT);

ChartSetInteger(0,CHART_COLOR_BACKGROUND,clrWhite);
ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,clrGreen);
ChartSetInteger(0,CHART_COLOR_CHART_UP,clrGreen);
ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,clrRed);
ChartSetInteger(0,CHART_COLOR_CHART_DOWN,clrRed);
ChartSetInteger(0,CHART_SHOW_GRID,false);
ChartSetInteger(0,CHART_COLOR_FOREGROUND,clrBlack );


ChartSetInteger(1,CHART_COLOR_BACKGROUND,clrBlack);
ChartSetInteger(1,CHART_COLOR_FOREGROUND,clrGreen );
ChartSetInteger(1,CHART_SHOW_GRID,false);

ChartSetInteger(0,CHART_MODE,CHART_CANDLES);
  
ChartSetInteger(0,CHART_SHOW_ASK_LINE,true);

   
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
int bars =iBars(_Symbol,PERIOD_CURRENT);


//createFibonacciObj();

if(bars > totalBars){
   totalBars = bars;
   
       datetime time = iTime(_Symbol, PERIOD_CURRENT, 1);
   double high = iHigh(_Symbol, PERIOD_CURRENT, 1);
   double low = iLow(_Symbol, PERIOD_CURRENT, 1);
 double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
 ask = NormalizeDouble(ask,_Digits);
 double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   bid = NormalizeDouble(bid,_Digits);
   
 double tpBuy = ask + TpPoints * _Point;
 tpBuy = NormalizeDouble(tpBuy,_Digits);
 
  double slBuy = ask - SlPoints * _Point;
 slBuy = NormalizeDouble(slBuy,_Digits);
 
 
  double tpSell = bid - TpPoints * _Point;
 tpSell = NormalizeDouble(tpSell,_Digits);
 
  double slSell = bid + SlPoints * _Point;
 slSell = NormalizeDouble(slSell,_Digits);
 
 CopyBuffer(EMA25Handle,MAIN_LINE,1,2,EMA25Buffer);
    CopyBuffer(EMA50Handle,MAIN_LINE,1,2,EMA50Buffer);
     CopyBuffer(EMA100Handle,MAIN_LINE,1,2,EMA100Buffer);
     CopyBuffer(EMA200Handle,MAIN_LINE,1,2,EMA200Buffer);
     CopyBuffer(MACDHandle,MAIN_LINE,1,2,MACDBuffer);
     CopyBuffer(MACDHandle,SIGNAL_LINE,1,2,signalBuffer);
     CopyBuffer(StochHandle,MAIN_LINE,1,2,StochBuffer);
     
     
     if(StochBuffer[1] < 80 && StochBuffer[0] > 20){
     // createObj(time, high, 234, clrRed, "Sell Schosctatic");
       //      trade.Sell(0.01, _Symbol, bid, 0, tpSell);
     }
     else if(StochBuffer[1] > 20 && StochBuffer[0] < 80){
       //           createObj(time,low,233,clrBlack,"Buy Schostatic");
     //trade.Buy(0.01,_Symbol,0,slBuy,tpBuy);
     }
     
     
     if(MACDBuffer[1] && signalBuffer[0] < signalBuffer[0]){


             createObj(time,low,233,clrBlack,"Buy MACD");
     trade.Buy(0.01,_Symbol,0,slBuy,tpBuy);
     }
     else if(MACDBuffer[1] < signalBuffer[1] && MACDBuffer[0] > signalBuffer[0]){
  
           createObj(time, high, 234, clrRed, "Sell MACD");
             trade.Sell(0.01, _Symbol, bid, 0, tpSell);
     }
    
     
     
  double emaDistance1 = MathAbs(EMA25Buffer[1]- EMA50Buffer[1]);
  double emaDistance2 = MathAbs(EMA50Buffer[1]- EMA100Buffer[1]);
  double minimumDistance = SymbolInfoDouble(_Symbol,SYMBOL_POINT) * 10; 
  
  double closePrice1 = iClose(_Symbol,PERIOD_CURRENT,1);
  double closePrice2 = iClose(_Symbol,PERIOD_CURRENT,2);

  if(emaDistance1 > minimumDistance && emaDistance2 > minimumDistance){
 // Print("Distance satisfied,more than 10pips");
      
      if(closePrice1 > EMA25Buffer[1] && closePrice1 > EMA50Buffer[1] && closePrice1 > EMA100Buffer[1]){
      // Print("Uptrend Indication");
         if(closePrice1 > EMA25Buffer[1] && closePrice2 < EMA25Buffer[0]){
            //intial corsover
//Print("Has crossed below");
            hasCrossedBelow  = true;
         }
         else if (closePrice1 > EMA25Buffer[1] && closePrice2 > EMA25Buffer[0] && hasCrossedBelow ){
             double stopLoss = NormalizeDouble(EMA50Buffer[1],_Digits);
             double takeProfit = NormalizeDouble(stopLoss * 1.5, _Digits);
             string timeframe = EnumToString(Period());
             //sendSignal("BUY", ask, tpBuy, timeframe);
              //trade.Buy(0.01,_Symbol,0,stopLoss,takeProfit);
              Print("Close Proce1 ",closePrice1,"\n","Close Proce 2 ",closePrice2,"\n Ema buffer 0 is ",EMA25Buffer[0],"\n","Ema Buffer 1 is ",EMA25Buffer[1]);
               hasCrossedBelow = false;
         }
        

      }
      
    
if (closePrice1 < EMA25Buffer[1] && closePrice1 < EMA50Buffer[1] && closePrice1 < EMA100Buffer[1]) {
    // Print("Downtrend Indication");
            double stopLoss = NormalizeDouble(EMA50Buffer[1], _Digits);
        double takeProfit = NormalizeDouble(stopLoss * -1.5, _Digits);
         double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   bid = NormalizeDouble(bid,_Digits);
          double slSell = bid + 50 * _Point;
          
            double tpSell = bid - 100 * _Point;
 tpSell = NormalizeDouble(tpSell,_Digits);
 
        
double stopLossPoints = (stopLoss - closePrice1) / SymbolInfoDouble(_Symbol, SYMBOL_POINT);
double takeProfitPoints = (takeProfit - closePrice1) / SymbolInfoDouble(_Symbol, SYMBOL_POINT);
string timeframe = EnumToString(Period());
//sendSignal("SELL", bid, tpSell, timeframe);



    if (closePrice1 < EMA25Buffer[1] && closePrice2 > EMA25Buffer[0]) {
        // Initial crossover
        // Print("Has crossed above");
        hasCrossedAbove = true;
    }
    else if (closePrice1 < EMA25Buffer[1] && closePrice2 < EMA25Buffer[0] && hasCrossedAbove) {
        // Pullback on 25EMA
        double stopLoss = NormalizeDouble(EMA50Buffer[1], _Digits);
        double takeProfit = NormalizeDouble(stopLoss * 1.5, _Digits);
     string timeframe = EnumToString(Period());
       // sendSignal("SELL", bid, tpSell, timeframe);
        
        hasCrossedAbove = false;
    }
}

  
  }
     
   if (IsHammer) {
   int hammerSignal = getHammerSignal(0.05, 0.7);
   
   if (hammerSignal > 0) {
      // Open buy position
      string timeframe = EnumToString(Period());
  
      sendSignal("BUY", ask, tpBuy, timeframe);
     // if (_Symbol == "XAUUSD")
      //   trade.Buy(0.01, _Symbol, ask, 0, tpBuy, "Hammer");
//else
      //   trade.Buy(Lots, _Symbol, ask, 0, tpBuy, "Hammer");
   }
   else if (hammerSignal < 0) {
      string timeframe = EnumToString(Period());
      sendSignal("SELL", bid, tpSell, timeframe);
//if (_Symbol == "XAUUSD")
   //      trade.Sell(0.01, _Symbol, bid, 0, tpSell, "Hammer");
   //   else
    //     trade.Sell(Lots, _Symbol, bid, 0, tpSell, "Hammer");
   }
}

if (IsEngulfing) {
   int engulfingSignal = getEngulfing();
   if (engulfingSignal > 0) {
      // Open buy position
      string timeframe = EnumToString(Period());
   //   if (_Symbol == "XAUUSD")
//trade.Buy(0.01, _Symbol, ask, 0, tpBuy, "Bullish Engulfing");
//else
   //      trade.Buy(Lots, _Symbol, ask, 0, tpBuy, "Bullish Engulfing");
      sendSignal("BUY", ask, tpBuy, timeframe);
   }
   else if (engulfingSignal < 0) {
      string timeframe = EnumToString(Period());
    //  if (_Symbol == "XAUUSD")
     //    trade.Sell(0.01, _Symbol, bid, 0, tpSell, "Bearing Engulfing");
     // else
     //    trade.Sell(Lots, _Symbol, bid, 0, tpSell, "Bearing Engulfing");
    //  sendSignal("SELL", bid, tpSell, timeframe);
   }
}

if (IsStar) {
   int starSignal = getStarSignal(0.5);

   if (starSignal > 0) {
      // Open buy position
      string timeframe = EnumToString(Period());
      string comment = "Morning Star Signal - " + timeframe;
   //   if (_Symbol == "XAUUSD")
    //     trade.Buy(0.01, _Symbol, ask, 0, tpBuy, comment);
    //  else
// trade.Buy(Lots, _Symbol, ask, 0, tpBuy, comment);
      sendSignal("BUY", ask, tpBuy, timeframe);
   }
   else if (starSignal < 0) {
      string timeframe = EnumToString(Period());
    //  if (_Symbol == "XAUUSD")
//trade.Sell(0.01, _Symbol, bid, 0, tpSell, "Evening Star Signal");
    //  else
    //     trade.Sell(Lots, _Symbol, bid, 0, tpSell, "Evening Star Signal");
      sendSignal("SELL", bid, tpSell, timeframe);
   }
}



  }
   }
//+------------------------------------------------------------------+

int getStarSignal(double maxMiddleCandleRatio){

   datetime time = iTime(_Symbol, PERIOD_CURRENT, 1);
   double high1 = iHigh(_Symbol, PERIOD_CURRENT, 1);
   double low1 = iLow(_Symbol, PERIOD_CURRENT, 1);
   double open1 = iOpen(_Symbol, PERIOD_CURRENT, 1);
   double close1 = iClose(_Symbol, PERIOD_CURRENT, 1);
     
   datetime time2 = iTime(_Symbol, PERIOD_CURRENT, 2);
   double high2 = iHigh(_Symbol, PERIOD_CURRENT, 2);
   double low2 = iLow(_Symbol, PERIOD_CURRENT, 2);
   double open2 = iOpen(_Symbol, PERIOD_CURRENT, 2);
   double close2 = iClose(_Symbol, PERIOD_CURRENT, 2);
   
   double high3 = iHigh(_Symbol, PERIOD_CURRENT, 3);
   double low3 = iLow(_Symbol, PERIOD_CURRENT, 3);
   double open3 = iOpen(_Symbol, PERIOD_CURRENT, 3);
   double close3 = iClose(_Symbol, PERIOD_CURRENT, 3);
   
   double size1 = high1 - low1;
   double size2 = high2 - low2;
   double size3 = high3 - low3;
   
   if(open1 < close1){
      if(open3 > close3){
         if(size2 < size1  && size2 < size3 ){
            createObj(time, low3, 233, clrBrown, "Weak Buy");
            return 1;
         }
      }
   }
   
     if(open1 < close1){
      if(open3 > close3){
         if(size2 < size1 * maxMiddleCandleRatio && size2 < size3 * maxMiddleCandleRatio){
            createObj(time, low2, 233, clrGreen, "Buy");
            return 1;
         }
      }
   }
   
   
    if(open1 > close1){
      if(open3 < close3){
         if(size2 < size1 * maxMiddleCandleRatio && size2 < size3 * maxMiddleCandleRatio){
            createObj(time, high2, 234, clrRed, "Sell");
            return -1;
         }
      }
   }
   
   
      if(open1 > close1){
      if(open3 < close3){
         if(size2 < size1  && size2 < size3){
            createObj(time, high3, 234, clrBlue, "Weak Sell");
            return -1;
         }
      }
   }
   
   
   return 0;
}


int getEngulfing() {
   datetime time1 = iTime(_Symbol, PERIOD_CURRENT, 1);
   double high1 = iHigh(_Symbol, PERIOD_CURRENT, 1);
   double low1 = iLow(_Symbol, PERIOD_CURRENT, 1);
   double open1 = iOpen(_Symbol, PERIOD_CURRENT, 1);
   double close1 = iClose(_Symbol, PERIOD_CURRENT, 1);
     
   datetime time2 = iTime(_Symbol, PERIOD_CURRENT, 2);
   double high2 = iHigh(_Symbol, PERIOD_CURRENT, 2);
   double low2 = iLow(_Symbol, PERIOD_CURRENT, 2);
   double open2 = iOpen(_Symbol, PERIOD_CURRENT, 2);
   double close2 = iClose(_Symbol, PERIOD_CURRENT, 2);
   
   // Bullish engulfing
   if (open1 < close1) {
      if (open2 > close2) {
         if (high1 > high2 && low1 < low2) {
            if(close1 > open2 && open1 < close2){
            createObj(time1, low1, 217, clrGreen, "Buy");
            return 1;
            }
         }
      }
   }
      
   if (open1 > close1) {
      if (open2 < close2) {
         if (high1 > high2 && low1 < low2) {
            if(close1 < open2 && open1 > close2){
                 createObj(time1, high1, 234, clrRed, "Sell");
                  return -1; 
            }
          
         }
      }
   }
   
   // No engulfing pattern found
   return 0;
}



int getHammerSignal(double maxRationShortShadow,double minRatioLongShadow)
{
datetime time = iTime(_Symbol,PERIOD_CURRENT,1);
   double high = iHigh(_Symbol,PERIOD_CURRENT,1);
   double low = iLow(_Symbol,PERIOD_CURRENT,1);
    double open = iOpen(_Symbol,PERIOD_CURRENT,1);
     double close = iClose(_Symbol,PERIOD_CURRENT,1);


double candleSize = high - low ;    
      
     // green hammer formation
     if(open < close){
         if(high - close < candleSize * maxRationShortShadow){
            if(open - low > candleSize * minRatioLongShadow){
            
            createObj(time,low,233,clrGreen,"Buy");
            
            
            
            
               return 1;
            }
         }
     }
     
          // green hammer formation
     if(open > close){
         if(high - open < candleSize * 0.1){
            if(close - low > candleSize * 0.6){
             createObj(time,low,233,clrRed,"Buy");
               return 1;
            }
         }
     }
     
     if(open > close){
         if(close - low < candleSize * maxRationShortShadow){
            if(high - open > candleSize * minRatioLongShadow){
            createObj(time,high,234,clrRed,"Sell");
               return -1;
            }
         }
     }
     
        if(open < close){
         if(open - low < candleSize * maxRationShortShadow){
            if(high - close > candleSize * minRatioLongShadow){
            createObj(time,high,234,clrRed,"Sell");
               return -1;
            }
         }
     }
     
     
   return 0;
}


void createObj(datetime time,double price,int arrowCode,color clr,string txt){
   string objName = "";
   StringConcatenate(objName,"Signal@",time," at ",DoubleToString(price,_Digits),"(",arrowCode,")");
   if(ObjectCreate(0,objName,OBJ_ARROW,0,time,price)){
   ObjectSetInteger(0,objName,OBJPROP_ARROWCODE,arrowCode);
   ObjectSetInteger(0,objName,OBJPROP_COLOR,clr);
   }
   string objNameDesc = objName + txt;
   if(ObjectCreate(0,objNameDesc,OBJ_TEXT,0,time,price)){
   ObjectSetString(0,objNameDesc,OBJPROP_TEXT,txt);
   ObjectSetInteger(0,objNameDesc,OBJPROP_COLOR,clr);
   }
   
  // string objNameLine = objName + " line ";
  //    if(ObjectCreate(0,objNameLine,OBJ_HLINE,0,time,price)){
// ObjectSetInteger(0,objNameLine,OBJPROP_COLOR,clr);
 //  }
  
   
   
   
   
}


bool SendTelegramMessage( string url, string token, string chat, string text,
                          string fileName = "" ) {

   string headers    = "";
   string requestUrl = "";
   char   postData[];
   char   resultData[];
   string resultHeaders;
   int    timeout = 5000; // 1 second, may be too short for a slow connection

   ResetLastError();

   if ( fileName == "" ) {
      requestUrl =
         StringFormat( "%s/bot%s/sendmessage?chat_id=%s&text=%s", url, token, chat, text );
   }
   else {
      requestUrl = StringFormat( "%s/bot%s/sendPhoto", url, token );
      if ( !GetPostData( postData, headers, chat, text, fileName ) ) {
         return ( false );
      }
   }

   ResetLastError();
   int response =
      WebRequest( "POST", requestUrl, headers, timeout, postData, resultData, resultHeaders );

   switch ( response ) {
   case -1: {
      int errorCode = GetLastError();
      Print( "Error in WebRequest. Error code  =", errorCode );
      if ( errorCode == UrlDefinedError ) {
         //--- url may not be listed
         PrintFormat( "Add the address '%s' in the list of allowed URLs", url );
      }
      break;
   }
   case 200:
      //--- Success
      Print( "The message has been successfully sent" );
      break;
   default: {
      string result = CharArrayToString( resultData );
      PrintFormat( "Unexpected Response '%i', '%s'", response, result );
      break;
   }
   }

   return ( response == 200 );
}

bool GetPostData( char &postData[], string &headers, string chat, string text, string fileName ) {

   ResetLastError();

   if ( !FileIsExist( fileName ) ) {
      PrintFormat( "File '%s' does not exist", fileName );
      return ( false );
   }

   int flags = FILE_READ | FILE_BIN;
   int file  = FileOpen( fileName, flags );
   if ( file == INVALID_HANDLE ) {
      int err = GetLastError();
      PrintFormat( "Could not open file '%s', error=%i", fileName, err );
      return ( false );
   }

   int   fileSize = ( int )FileSize( file );
   uchar photo[];
   ArrayResize( photo, fileSize );
   FileReadArray( file, photo, 0, fileSize );
   FileClose( file );

   string hash = "";
   AddPostData( postData, hash, "chat_id", chat );
   if ( StringLen( text ) > 0 ) {
      AddPostData( postData, hash, "caption", text );
   }
   AddPostData( postData, hash, "photo", photo, fileName );
   ArrayCopy( postData, "--" + hash + "--\r\n" );

   headers = "Content-Type: multipart/form-data; boundary=" + hash + "\r\n";

   return ( true );
}

void AddPostData( uchar &data[], string &hash, string key = "", string value = "" ) {

   uchar valueArr[];
   StringToCharArray( value, valueArr, 0, StringLen( value ) );

   AddPostData( data, hash, key, valueArr );
   return;
}

void AddPostData( uchar &data[], string &hash, string key, uchar &value[], string fileName = "" ) {

   if ( hash == "" ) {
      hash = Hash();
   }

   ArrayCopy( data, "\r\n" );
   ArrayCopy( data, "--" + hash + "\r\n" );
   if ( fileName == "" ) {
      ArrayCopy( data, "Content-Disposition: form-data; name=\"" + key + "\"\r\n" );
   }
   else {
      ArrayCopy( data, "Content-Disposition: form-data; name=\"" + key + "\"; filename=\"" +
                          fileName + "\"\r\n" );
   }
   ArrayCopy( data, "\r\n" );
   ArrayCopy( data, value, ArraySize( data ) );
   ArrayCopy( data, "\r\n" );

   return;
}

void ArrayCopy( uchar &dst[], string src ) {

   uchar srcArray[];
   StringToCharArray( src, srcArray, 0, StringLen( src ) );
   ArrayCopy( dst, srcArray, ArraySize( dst ), 0, ArraySize( srcArray ) );
   return;
}

string Hash() {

   uchar  tmp[];
   string seed = IntegerToString( TimeCurrent() );
   int    len  = StringToCharArray( seed, tmp, 0, StringLen( seed ) );
   string hash = "";
   for ( int i = 0; i < len; i++ )
      hash += StringFormat( "%02X", tmp[i] );
   hash = StringSubstr( hash, 0, 16 );

   return ( hash );
}


int sendSignal(string direction,double entryLevel,double takeProfit,string timeframe){



   // Added because bmp files seem to have stopped working, possibly a file format issue
   string fileType = "png";
   string fileName = "MyScreenshot." + fileType;

   // Save a screen shot
   ChartRedraw(); // Make sure the chart is up to date
   ChartScreenShot( 0, fileName, 1024, 768, ALIGN_RIGHT );
   
   //SendTelegramMessage( TelegramApiUrl, TelegramBotToken, ChatId,
   //                             "Test message " + TimeToString( TimeLocal() ) ); // no image attached
   
string message = "Trade: " + direction + _Symbol + "\n"
                 "Entry Level: " + DoubleToString(entryLevel) + "\n"
                 "Take Profit: " + DoubleToString(takeProfit) + "\n";
                // "Stop Loss: " + DoubleToString(stopLoss) + "\n"
                // "Risk: " + DoubleToString(risk) + "% \n";

SendTelegramMessage(TelegramApiUrl, TelegramBotToken, ChatId, message + TimeToString(TimeLocal()), fileName);

    Alert(message);
   return 0;
}









void SetEmojiToMsg(string &text, int emoji)

{

   StringSetCharacter(text, 0, emoji);

}
