// import 'package:ParvaazFoundation/model/application.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:cupertino_stepper/cupertino_stepper.dart';

// class CustomStepper extends StatefulWidget {
//   CustomStepper({Key key, this.objComment}) : super(key: key);
//   final Application objComment;
//   @override
//   _CustomStepperState createState() => _CustomStepperState();
// }

// class _CustomStepperState extends State<CustomStepper> {
//   int currentStep = 0;

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       navigationBar: CupertinoNavigationBar(
//         middle: Text('Application Progress'),
//       ),
//       child: SafeArea(
//         child: OrientationBuilder(
//           builder: (BuildContext context, Orientation orientation) {
//             switch (orientation) {
//               case Orientation.portrait:
//                 return _buildStepper(StepperType.vertical, widget.objComment);
//               case Orientation.landscape:
//                 return _buildStepper(StepperType.horizontal, widget.objComment);
//               default:
//                 throw UnimplementedError(orientation.toString());
//             }
//           },
//         ),
//       ),
//     );
//   }

//   CupertinoStepper _buildStepper(StepperType type, Application obj) {
//     final canCancel = currentStep > 0;
//     final canContinue = currentStep < 3;
//     return CupertinoStepper(
//       type: type,
//       currentStep: currentStep,
//       onStepTapped: (step) => setState(() => currentStep = step),
//       onStepCancel: canCancel ? () => setState(() => --currentStep) : null,
//       onStepContinue: canContinue ? () => setState(() => ++currentStep) : null,
//       steps: [
//         _buildStep(
//           title: Text(
//             'Reviewer',
//             style: TextStyle(fontSize: 20),
//           ),
//           subtitle: Text(obj?.reviewStatus),
//           remark: Text(obj.reviewerRemark == null ? "" : obj.reviewerRemark),
//           state: obj.reviewStatus.toUpperCase() == "REJECTED"
//               ? StepState.error
//               : obj.reviewStatus.toUpperCase() == "PENDING"
//                   ? StepState.disabled
//                   : obj.reviewStatus.toUpperCase() == "APPROVED"
//                       ? StepState.complete
//                       : StepState.editing,
//         ),
//         _buildStep(
//           title: Text(
//             'Surveyor',
//             style: TextStyle(fontSize: 20),
//           ),
//           subtitle: Text(obj?.surveyStatus),
//           remark: Text(obj.surveyorRemark == null ? "" : obj.surveyorRemark),
//           state: obj.surveyStatus.toUpperCase() == "REJECTED"
//               ? StepState.error
//               : obj.surveyStatus.toUpperCase() == "PENDING"
//                   ? StepState.disabled
//                   : obj.surveyStatus.toUpperCase() == "APPROVED"
//                       ? StepState.complete
//                       : StepState.editing,
//         ),
//         _buildStep(
//           title: Text(
//             'Approver',
//             style: TextStyle(fontSize: 20),
//           ),
//           subtitle: Text(obj?.approvalStatus),
//           remark: Text(obj.approverRemark == null ? "" : obj.approverRemark),
//           state: obj.approvalStatus.toUpperCase() == "REJECTED"
//               ? StepState.error
//               : obj.approvalStatus.toUpperCase() == "PENDING"
//                   ? StepState.disabled
//                   : obj.approvalStatus.toUpperCase() == "APPROVED"
//                       ? StepState.complete
//                       : StepState.editing,
//         ),

//         // for (var i = 0; i < 3; ++i)
//         //   _buildStep(
//         //     title: Text('Step ${i + 1}'),
//         //     remark: Text('My Remarks'),
//         //     isActive: i == currentStep,
//         //     state: i == currentStep
//         //         ? StepState.editing
//         //         : i < currentStep
//         //             ? StepState.complete
//         //             : StepState.indexed,
//         //   ),
//         // _buildStep(
//         //   title: Text('Error'),
//         //   state: StepState.error,
//         // ),
//         // _buildStep(
//         //   title: Text('Disabled'),
//         //   state: StepState.disabled,
//         // )
//       ],
//     );
//   }

//   Step _buildStep({
//     @required Widget title,
//     @required Widget subtitle,
//     @required Widget remark,
//     StepState state = StepState.indexed,
//     bool isActive = false,
//   }) {
//     return Step(
//       title: title,
//       subtitle: subtitle,
//       state: state,
//       isActive: isActive,
//       content: LimitedBox(
//         maxWidth: 100,
//         maxHeight: 100,
//         child: Container(
//           color: CupertinoColors.lightBackgroundGray,
//           child: remark,
//         ),
//       ),
//     );
//   }
// }
