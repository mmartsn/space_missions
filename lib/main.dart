import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_missions/api_client.dart';
import 'package:space_missions/blocs/blocs.dart';

void main() {
  runApp(MyApp(missionsApiClient: MissionsApiClient.create()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.missionsApiClient}) : super(key: key);

  final MissionsApiClient missionsApiClient;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GraphQL Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.white,
            onSurface: Colors.white,
          ),
        ),
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                MissionsBloc(missionsApiClient: missionsApiClient)
                  ..add(MissionsFetchStarted(0, 10, '')),
          ),
          BlocProvider(
            create: (context) => PageNumberCubit(),
          ),
        ],
        child: const MyHomePage(),
      ),
    );
    //);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const _pageSize = 10;
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    BlocProvider.of<PageNumberCubit>(context).pageByNumber(1);

    super.initState();
  }

  Future<void> _fetchPage(int pageNumber) async {
    final missionsBloc = context.read<MissionsBloc>();
    final pageNumberCubit = context.read<PageNumberCubit>();
    final offset = (pageNumberCubit.state - 1) * _pageSize;
    final query = controller.text;

    if ([1, 2, 3].contains(query.length)) {
      return;
    }
    missionsBloc.add(MissionsFetchStarted(offset, _pageSize, query));
    if (context.read<MissionsBloc>().state is MissionsLoadSuccess) {
      context.read<PageNumberCubit>().pageByNumber(pageNumber);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: AppBar(
            title: const Center(child: Text('SpaceX Missions')),
            backgroundColor: Colors.blueGrey,
          ),
        ),
        //resizeToAvoidBottomInset: false,
        body: BlocBuilder<MissionsBloc, MissionsState>(
          builder: (context, state) {
            if (state is MissionsLoadInProgress) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is MissionsLoadSuccess) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        size: 30,
                      ),
                      hintText: 'Search by Mission name',
                      hintStyle: TextStyle(fontSize: 18),
                    ),
                    onChanged: (query) async {
                      await _fetchPage(1);
                    },
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.missions.length,
                      itemBuilder: (context, index) {
                        final mission = state.missions[index];
                        return ListTile(
                            title: Text(mission.missionName),
                            subtitle: Text(mission.details));
                      },
                    ),
                  ),
                ],
              );
            }
            return const Text('Oops something went wrong!');
          },
        ),

        bottomNavigationBar: BottomAppBar(
            color: Colors.blueGrey,
            child: SizedBox(
                height: 40,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BlocBuilder<PageNumberCubit, int>(
                        builder: (context, state) {
                          return TextButton(
                              onPressed:
                                  (context.read<PageNumberCubit>().state == 1)
                                      ? null
                                      : () async {
                                          final currentPage = context
                                              .read<PageNumberCubit>()
                                              .state;
                                          await _fetchPage(currentPage - 1);
                                          if (context.read<MissionsBloc>().state
                                              is MissionsLoadSuccess) {
                                            context
                                                .read<PageNumberCubit>()
                                                .pageByNumber(currentPage - 1);
                                          }
                                        },
                              child: const Icon(
                                Icons.chevron_left,
                                size: 30,
                              ));
                        },
                      ),
                      BlocBuilder<PageNumberCubit, int>(
                        builder: (context, state) {
                          return Text(state.toString(),
                              style: const TextStyle(
                                  color: Color(0x5DFFFFFF), fontSize: 20));
                        },
                      ),
                      BlocBuilder<MissionsBloc, MissionsState>(
                        builder: (context, state) {
                          return TextButton(
                              onPressed: (state is MissionsLoadSuccess)
                                  ? state.missions.length < _pageSize
                                      ? null
                                      : () async {
                                          final currentPage = context
                                              .read<PageNumberCubit>()
                                              .state;
                                          await _fetchPage(currentPage + 1);
                                          if (state is MissionsLoadSuccess &&
                                              state.missions.isNotEmpty) {
                                            context
                                                .read<PageNumberCubit>()
                                                .pageByNumber(currentPage + 1);
                                          }
                                        }
                                  : null,
                              child: const Icon(
                                Icons.chevron_right,
                                size: 30,
                              ));
                        },
                      ),
                    ]))),
      ),
    );
  }
}
