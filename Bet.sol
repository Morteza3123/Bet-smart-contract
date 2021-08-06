// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Bet {
    
    uint16 totallParticipant;//جمع تعداد شرکت کننده ها
    uint totallAmount; //جمع مبلغ داخل قرار داد      
    uint firstNumberTotal;//جمع بلیط های شماره یک
    uint secondNumberTotal;//جمع بلیط های شماره ی دو
    uint thirdNumberTotal;//جمع بلیط های شماره ی سه
    uint startMatchTime;//زمان شروع مسابقه
    uint finishMatchTime;//زمان پایان مسابقه
    uint winnerReward;//جایزه ی هر بلیط برنده
    uint winNumber;// شماره بلیط برنده
    address admin;//آدرس مدیر 
    
    
    
    mapping(address => bool)  OnlyOnce;//هر آدرس یک بلیط
    mapping(address=> uint )  ticketNumber;//شماره بلیط بین یک تا سه
    mapping(address => bool)  hasRecievedReward;//جایزه دریافت شده یا خیر
    
   
   
   constructor(){
       admin = msg.sender;//ادمین مشخص می شود
   }
   
   
   
   
   //قیمت هر بلیط یک اتریوم
   modifier requireEther() {
       require(msg.value == 1 ether , "value must be equall 1 ether");
       _;
   }
   
   
   
   
   //شماره هر بلیط فقط بین یک تا سه
   modifier limitedTicketNumber(uint _num) {
      require(  _num > 0 && _num <=3 , "ticket Number must be 1 or 2 or 3" ) ;
      _;
   }
   
   
   
   
   //هر آدرس فقط حق خرید یک بلیط را دارد
   modifier onlyOnce() {
      require(OnlyOnce[msg.sender] == false , "you have bought ticket befor");
      _;
   }
   
   
   
   
   
   
   //دستور خرید بلیط
   function payingamount(uint _number) public  payable requireEther limitedTicketNumber(_number) onlyOnce   {
        require(block.timestamp < startMatchTime);//مسابقه هنوز شروع نشده باشد
        ticketNumber[msg.sender] = _number;//بلیط به آدرس تعلق می گیرد
        OnlyOnce[msg.sender] = true;//مشخص می کنیم از الان به بعد بلیط را گرفته است
        totallParticipant++;//به تعداد شرکت کنندگان یک عدد اضافه می کنیم
        totallAmount = address(this).balance ;//مبغ قرار داد تا اینجای کار را ذخیره می کنیم
        if(_number==1){
          firstNumberTotal++;  //اگر بلیط یک را خریده باشد به تعداد شرکت کنندگان دسته اول یکی اضافه شود
        }
        if(_number==2){
          secondNumberTotal++; //اگر بلیط شماره دو را خریده باشد به تعدادشرکت کنندگان شماره دو یکی اضافه شود
        }
        if(_number==3){
          thirdNumberTotal++;  //اگر بلیط شماره سه را خریده باشد به تعداد شرکت کنندگان شماره سه یکی اضافه شود
        }
   }
   
   
   
   
   
   
   //نشان دادن موجودی قرار داد
   function showContractBalance() public view returns(uint){
       return address(this).balance;
   }
   
   
   
   
   
   
   //پایان بازی و تقسیم مبلغ قرارداد بین شرکت کنندگان بلیط برنده
   function betFinished(uint _winNumber) public {
       require(block.timestamp > finishMatchTime);
       require(msg.sender==admin, "Yor are not admin");
       winNumber = _winNumber ;
       if(_winNumber==1){
         winnerReward = totallAmount/firstNumberTotal;
       }
       if(_winNumber==2){
         winnerReward = totallAmount/secondNumberTotal;
       }
       if(_winNumber==2){
         winnerReward = totallAmount/thirdNumberTotal; 
       }
   }
   
   
   
   
   
   
   
   //مراجعه آدرس برنده و پرداخت جایزه
   function giveReward()public payable {
       require(ticketNumber[msg.sender]==winNumber, "Your ticket has not been won");
       require(hasRecievedReward[msg.sender]==false , "you have recieved reward");
       hasRecievedReward[msg.sender]==true;
       //msg.sender.transfer(winnerReward);
       payable(msg.sender).transfer(winnerReward);
       }
   
   
    
}
