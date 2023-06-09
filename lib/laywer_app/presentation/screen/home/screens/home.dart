import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hokok/core/constant.dart';
import 'package:hokok/core/debug_prints.dart';
import 'package:hokok/core/font_manager.dart';
import 'package:hokok/core/shared_widget/empty_data_shared_widget.dart';
import 'package:hokok/domain/entities/major_entity.dart';
import 'package:hokok/domain/entities/public_order_entity.dart';
import 'package:hokok/domain/entities/user_entity.dart';
import 'package:hokok/presentation/blocs/auth_bloc/auth_helper.dart';
import 'package:hokok/presentation/blocs/major_bloc/major_bloc.dart';
import 'package:hokok/presentation/blocs/major_bloc/major_helper.dart';
import 'package:hokok/presentation/blocs/major_bloc/major_states.dart';
import 'package:hokok/presentation/blocs/order_bloc/order_bloc.dart';
import 'package:hokok/presentation/blocs/order_bloc/order_helper.dart';
import 'package:hokok/presentation/blocs/order_bloc/order_states.dart';
import 'package:hokok/presentation/blocs/profile_bloc/profile_bloc.dart';
import 'package:hokok/presentation/blocs/profile_bloc/profile_helper.dart';
import 'package:hokok/presentation/blocs/profile_bloc/profile_states.dart';
import '../../../../../core/assets_manager.dart';
import '../../../../../core/color_manager.dart';
import '../../../../../core/values_manager.dart';
import '../../../../../presentation/widget/shared_widget.dart';

class HomeLawyerScreen extends StatefulWidget {
  const HomeLawyerScreen({Key? key}) : super(key: key);

  @override
  State<HomeLawyerScreen> createState() => _HomeLawyerScreenState();
}

class _HomeLawyerScreenState extends State<HomeLawyerScreen> {
  @override
  void initState() {
    ProfileHelper.instance().getLawyerProfileAction(context);
    OrderHelper.instance().getPublicOrdersForLawyerAction(context);
    MajorHelper.instance().getMajorsActionCon(context);

    super.initState();
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _appBar(context),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      showFilterPublicOrderSheet(context);
                    },
                    child: const Icon(
                      Icons.filter_list,
                      size: 30,
                    ),
                  ),
                  BlocConsumer<OrderBloc, OrderStates>(
                      listener: (context, state) {
                    if (state is OrderFailedLoadedState) {
                      state.authErrorMessage(context, state.error);
                    }
                  }, builder: (context, state) {
                    if (state is PublicOrderLoadedState) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: state.orders!.length,
                          itemBuilder: (context, index) {
                            return OrderView(order: state.orders![index]);
                          },
                        ),
                      );
                    } else if (state is OrderLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is OrderFailedLoadedState) {
                      return emptyDataSharedWidget();
                    }
                    return Container();
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showFilterPublicOrderSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width -
            40, // here increase or decrease in width
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: StatefulBuilder(builder: (context, setState) {
            return Container(
              height: 250.h,
              margin: const EdgeInsets.only(
                left: 30,
                right: 30,
              ),
              padding: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.clear,
                        size: 30,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "الترتيب حسب",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: FontConstants.fontFamily,
                      color: ColorManager.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: defaultTextFiled(
                            onChange: (value) {
                              setState(() {
                                OrderHelper.instance().city = value;
                              });
                            },
                            inputType: TextInputType.text,
                            labelText: 'ادخل إسم المدينة',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'من فضلك ادخل المدينة';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        BlocBuilder<MajorBloc, MajorStates>(
                          builder: (context, state) {
                            List<MajorData>? majors = [];
                            if (state is MajorSuccessLoadedState) {
                              majors = state.majorsList;
                              printInfo("the majors are ${majors!.length}");
                            } else if (state is FailedLoadedState) {
                              majors = [];
                            }
                            return Container(
                              height: 65,
                              padding: const EdgeInsets.all(2),
                              margin: const EdgeInsets.only(bottom: 10, top: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                              ),
                              child: FormField<MajorData>(
                                builder: (FormFieldState<MajorData> state) {
                                  return InputDecorator(
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        //errorStyle: TextStyle(color: Colors.red[900], fontSize: 16.0),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(30.0))),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        dropdownColor: Colors.white,
                                        iconSize: 30,
                                        iconEnabledColor: Colors.red[900],
                                        hint: Text(
                                          'نوع القضية',
                                          style: TextStyle(
                                              color:
                                                  ConstantColor.primaryColor),
                                        ),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: FontConstants.fontFamily,
                                          color: ConstantColor.primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        value:
                                            OrderHelper.instance().majorValue,
                                        isDense: true,
                                        onChanged: (value) {
                                          setState(() {
                                            printInfo(
                                                "the id of major is $value");
                                            OrderHelper.instance().majorId =
                                                int.parse(value.toString());
                                            OrderHelper.instance().majorValue =
                                                value;
                                            printInfo(
                                                "the major id => ${OrderHelper.instance().majorId = int.parse(value.toString())}");
                                          });
                                        },
                                        items: majors!.map((MajorData value) {
                                          return DropdownMenuItem(
                                              value: value.id.toString(),
                                              child: Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5.0,
                                                          right: 5.0),
                                                  child: Text(
                                                    value.name.toString(),
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                              ));
                                        }).toList(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 110.w,
                          child: mainButton(
                            text: 'تأكيد',
                            fct: () {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  OrderHelper.instance()
                                      .getPublicOrdersForLawyerAction(context);
                                });
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  Container _appBar(BuildContext context) => Container(
        width: double.infinity,
        height: AppSize.s234,
        color: ColorManager.primary,
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            BlocConsumer<ProfileBloc, ProfileStates>(
                listener: (context, state) {
              if (state is ProfileFailedState) {
                state.authErrorMessage(context, state.error);
              }
            }, builder: (context, state) {
              if (state is ProfileLoadedState) {
                return UserPorfileWidget(state: state.userEntity!);
              } else if (state is ProfileFailedState) {
                return const UserPorfileWidget(state: null);
              } else if (state is ProfileLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Container();
            }),
            const Spacer(),
            InkWell(
              onTap: () {},
              child: const Icon(
                Icons.shopping_cart,
                color: ColorManager.thirdy,
                size: 30,
              ),
            ),
          ],
        ),
      );
}

class UserPorfileWidget extends StatelessWidget {
  const UserPorfileWidget({
    required this.state,
    super.key,
  });
  final UserEntity? state;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: AppSize.s105,
          width: AppSize.s116,
          margin: const EdgeInsets.only(top: AppMargin.m48),
          padding: const EdgeInsets.all(AppPadding.p10),
          decoration: BoxDecoration(
            border: Border.all(color: ColorManager.grey, width: 0.5),
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: CachedNetworkImage(
              height: 50,
              width: 50,
              fit: BoxFit.cover,
              imageUrl: state!.userModel!.personalImage!,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Image(
                image: AssetImage(AssetsManager.lawyerImg),
              ),
            ),
          ),
          //clipBehavior: Clip.antiAliasWithSaveLayer,
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          state == null ? "UnKnown" : state!.userModel!.name!,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: FontConstants.fontFamily,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 15,
              color: Colors.black87,
            ),
            Text(
              state == null ? "UnKnown" : state!.userModel!.city!,
              style: const TextStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: 12,
              ),
            )
          ],
        ),
      ],
    );
  }
}

class OrderView extends StatelessWidget {
  const OrderView({
    required this.order,
    super.key,
  });
  final OrderInfoModel order;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      width: double.maxFinite,
      margin: const EdgeInsets.only(bottom: 5, right: 5, left: 5),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.orangeAccent, width: .8),
        ),
      ),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              order.title.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontFamily: FontConstants.fontFamily,
                color: Colors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
            InkWell(
              onTap: () {},
              child: const Directionality(
                textDirection: TextDirection.ltr,
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 15,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                RowItems(
                  icon: Icons.hourglass_empty,
                  title: order.createdAt.toString(),
                ),
                const SizedBox(
                  width: 8,
                ),
                RowItems(
                  icon: Icons.bookmark_border,
                  title: "${order.requests} عروض",
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            Text(
              order.description.toString(),
              style: const TextStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RowItems extends StatelessWidget {
  const RowItems({
    required this.title,
    required this.icon,
    super.key,
  });
  final IconData? icon;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          size: 14,
          icon,
          color: Colors.grey,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          title.toString(),
          style: const TextStyle(
            fontFamily: FontConstants.fontFamily,
            color: Colors.grey,
            fontSize: 11,
          ),
        )
      ],
    );
  }
}
