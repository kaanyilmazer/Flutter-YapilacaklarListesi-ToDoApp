
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class KayitFormu extends StatefulWidget {
  const KayitFormu({Key? key}) : super(key: key);

  @override
  State<KayitFormu> createState() => _KayitFormuState();
}

String? kullaniciAdi, email, parola;
bool kayitDurumu = false;


class _KayitFormuState extends State<KayitFormu> {

  var _dogrulamaAnahtari = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _dogrulamaAnahtari,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.height,

        child: ListView(
          children: [
            Container(
              height: 150,
              child: Image.asset('img/todo.png'),
            ),
            if (!kayitDurumu)
              Padding(
                  padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (alinanAd) {
                  kullaniciAdi = alinanAd;
                },
                validator: (alinanAd){
                  return alinanAd!.isEmpty
                      ? "Kullanici Adini Bos BİRAKAMAZSİNNN!"
                      :null;
                },
                decoration: InputDecoration(
                  labelText: "Kullanici Adi :",
                  border: OutlineInputBorder(),
                ),
              ),),
            Padding(padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              onChanged:  (alinanEmail) {
                email = alinanEmail;
              },
              validator: (alinanEmail) {
                return alinanEmail!.contains("@")
                    ? null
                    :"Gecersiz Email !";
              },
              decoration: InputDecoration(
                labelText:  "Email:",
                border: OutlineInputBorder(),
              ),
            ),),
            Padding(
                padding: EdgeInsets.all(8.0),
            child: TextFormField(
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              onChanged: (alinanParola){
                parola = alinanParola;
              },
              validator: (alinanParola){
                return alinanParola!.length >=6
                    ? null
                    : "Parola en az 6 Karakter";
              },
              decoration:  InputDecoration(
                labelText: "Parola : ",
                border: OutlineInputBorder()
              ),
            ),),
               Padding(
                padding: EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              child: ElevatedButton(
                child: kayitDurumu
                ? Text("Giriş Yap", style: TextStyle(fontSize :24))
                : Text("Kayit OL",style: TextStyle(fontSize :24)),
                onPressed: () {
                  kayitEkle();
    },
                style: ElevatedButton.styleFrom(
                  primary:  Colors.red,
                  shadowColor: Colors.black26
                ),
              ),
            ),),
            Container(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: (){
                  setState(() {
                    kayitDurumu = !kayitDurumu;
                  });
                },
                child: kayitDurumu
                ? Text("Hesabin YOK")
                : Text("Zaten Hesabın Var"),
              ),
            )
          ],
        ),
      ),
    );
  }

  void kayitEkle() {
    if(_dogrulamaAnahtari.currentState!.validate()) {
      formuTestEt(kullaniciAdi!,email!,parola!);

    }
  }

  void formuTestEt(String kullaniciAdi, String email, String parola) async{
    final yetki= FirebaseAuth.instance;
    AuthCredential? yetkiSonucu;

    if(kayitDurumu) {
      yetkiSonucu =(await yetki.signInWithEmailAndPassword(email: email, password: parola)) as AuthCredential;
    }else {
      yetkiSonucu = (await yetki.createUserWithEmailAndPassword(email: email, password: parola)) as AuthCredential;

    }
    String uidTutucu = yetkiSonucu.toString();
    await FirebaseFirestore.instance.collection("kullanicilar").doc(uidTutucu).set(
        {"kullaniciAdi:" : kullaniciAdi , "email" : email});
  }
}
