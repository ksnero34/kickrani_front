# kickrani

PNU 2021 오픈SW, 오픈API 활용 해커톤
조랭이떡팀의 프론트(어플) 입니다.

## Getting Started
IOS, Android 둘다 사용 가능하며 활용하긴 위해서는 Flutter 프레임워크를 다운받을 필요가 있으며
IOS의 경우 Xcode를, Android는 Android Studio를 필요로 합니다.
VSCode 기준 Clone후 Run or Dedub를 통해 실행할 수 있습니다.

※정보들은 개인서버의 DB에 저장되어 있기 때문에 따로 DB를 구성하시기 바랍니다.

<img width="461" alt="스크린샷 2021-10-04 오후 10 54 27" src="https://user-images.githubusercontent.com/75108256/135942621-79c8991e-494d-403b-985f-2d21320e5f9c.png">

DB에 위와같이 테이블을 구성한뒤 WAS를 통해 어플에서 Http get 요청시 Json으로 파싱한 형태로 값을 반환시켜주면 됩니다.
express 기준 db와의 connect 설정후 아래와 같이 구성하시면 됩니다.

######################################


app.get("/", function(req, res){

    connection.query('SELECT * FROM catched', function(err, rows, fields){
    
        if(!err){
        
            res.send(rows);
            
            console.log('The solution is: ', rows);
            
        }
        
        else console.log('Error while performing Query.');
        
    });
    
});

app.get("/", function(req, res){

        res.send('kickwassssss')
        
});

app.use('/pic',express.static(__dirname+'/pic'));


######################################



지도활용 부분 : 
  구글 맵 API를 활용하기 위해 구글콘솔에서 구글맵 KEY를 발급받아 적용할 필요가 있습니다.
