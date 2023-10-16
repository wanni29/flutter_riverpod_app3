import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// 창고 데이터 -> 관리하기 편하려구, 하나의 필드값뿐만 아니라 여러개의 필드값이 들어온다 하더라도 대처가 가능하게 만들려고
class Model {
  int num;

  Model(this.num);
}

// 창고 class(상태, 행위) (Provider - 상태, StateNotifierProvider - 상태 + 메서드)
// Provider는 변수하나만 있어도 된다.
// StateNotifierProvider 상태와 메소드를 같이 들고 있기 때문에 class 를 들고 있어여 한다.
// 상태변경을 하려면 메소드가 필요하기때문이다.

// 데이터 관리는 클래스로 한다.
class ViewModel extends StateNotifier<Model?> {
  ViewModel(super.state);

  // StateNotifier얘가 실질적으로 상태를 관리한다.
  // 그래서 :super를통해서 상태를 전달해주면되는거다

  void init() {
    // init()이 가장먼저 실행될때 무엇을 하겠다는 함수구나
    // 통신 코드
    state = Model(1);
  }

  void change() {
    // 상태값을 변경하는 코드
    state = Model(2);
  }
}

// 창고 관리자
final numProvider = StateNotifierProvider<ViewModel, Model?>((ref) {
  return ViewModel(null)..init(); // 생성자 만들면서 함수 바로 실행하는코드
  // 왜 null 이 들어가지 ? 프로바이더는 화면이 그려지기 전에 초기화가 되야해
  // 통신이 되서 값을 그려지는데 통신을 하는 도중에 그림을 먼저 다그리기때문에
  // 지금 StateNotifierProvider는 Future를 써야 async 를 붙여야 하는데
  // StateNotifierProvider는 async지원이 안돼.
  // 창고에 관리하는 데이터가 null이야
  // 그러면 화면에 null을 그리겟찌
  // 근데 창고를 watch하고 있어
  // 창고를 watch 하고 있으니 값이 바껴도그림을 그리니까 문제가 해결이 되지!
});

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              MyText1(),
              MyText2(),
              MyText3(),
              MyButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class MyButton extends ConsumerWidget {
  const MyButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // WidgetRef ref 이친구를 통해서 창고관리자에게 접근할수있음
    return ElevatedButton(
      onPressed: () {
        ref.read(numProvider.notifier).change();
        //  ref.read(numProvider. -> 모델에 접근
        // ref.read(numProvider.notifier) -> view 모델에 접근
      },
      child: Text("상태변경"),
    );
  }
}

class MyText3 extends StatelessWidget {
  const MyText3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text("5", style: TextStyle(fontSize: 30));
  }
}

class MyText2 extends ConsumerWidget {
  const MyText2({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Model? model = ref.watch(numProvider);

    if (model == null) {
      return CircularProgressIndicator();
    } else {
      return Text("${model.num}", style: TextStyle(fontSize: 30));
    }
  }
}

class MyText1 extends ConsumerWidget {
  const MyText1({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Model? model = ref.watch(numProvider);

    if (model == null) {
      return CircularProgressIndicator();
    } else {
      return Text("${model.num}", style: TextStyle(fontSize: 30));
    }
  }
}
