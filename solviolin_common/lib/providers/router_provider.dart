import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/extensions/string_to_user_type_extension.dart';
import 'package:solviolin_common/pages/admin_menu_page.dart';
import 'package:solviolin_common/pages/branch_list_page.dart';
import 'package:solviolin_common/pages/branch_register_page.dart';
import 'package:solviolin_common/pages/branch_select_page.dart';
import 'package:solviolin_common/pages/canceled_list_page.dart';
import 'package:solviolin_common/pages/canceled_made_up_page.dart';
import 'package:solviolin_common/pages/canceled_search_page.dart';
import 'package:solviolin_common/pages/check_in_list_page.dart';
import 'package:solviolin_common/pages/check_in_page.dart';
import 'package:solviolin_common/pages/check_in_search_page.dart';
import 'package:solviolin_common/pages/control_list_page.dart';
import 'package:solviolin_common/pages/control_register_page.dart';
import 'package:solviolin_common/pages/control_search_page.dart';
import 'package:solviolin_common/pages/credit_initialize_page.dart';
import 'package:solviolin_common/pages/dow_select_page.dart';
import 'package:solviolin_common/pages/ledger_create_page.dart';
import 'package:solviolin_common/pages/ledger_list_page.dart';
import 'package:solviolin_common/pages/ledger_search_page.dart';
import 'package:solviolin_common/pages/ledger_total_page.dart';
import 'package:solviolin_common/pages/metronome_page.dart';
import 'package:solviolin_common/pages/reservation_create_page.dart';
import 'package:solviolin_common/pages/reservation_detail_page.dart';
import 'package:solviolin_common/pages/reservation_search_page.dart';
import 'package:solviolin_common/pages/reservation_slot_page.dart';
import 'package:solviolin_common/pages/salary_list_page.dart';
import 'package:solviolin_common/pages/salary_search_page.dart';
import 'package:solviolin_common/pages/sign_in_page.dart';
import 'package:solviolin_common/pages/student_make_up_page.dart';
import 'package:solviolin_common/pages/student_menu_page.dart';
import 'package:solviolin_common/pages/student_personal_page.dart';
import 'package:solviolin_common/pages/teacher_id_select_page.dart';
import 'package:solviolin_common/pages/teacher_list_page.dart';
import 'package:solviolin_common/pages/teacher_menu_page.dart';
import 'package:solviolin_common/pages/teacher_register_page.dart';
import 'package:solviolin_common/pages/teacher_search_page.dart';
import 'package:solviolin_common/pages/term_extend_branch_page.dart';
import 'package:solviolin_common/pages/term_extend_student_page.dart';
import 'package:solviolin_common/pages/term_list_page.dart';
import 'package:solviolin_common/pages/term_register_page.dart';
import 'package:solviolin_common/pages/term_select_page.dart';
import 'package:solviolin_common/pages/term_update_page.dart';
import 'package:solviolin_common/pages/user_detail_page.dart';
import 'package:solviolin_common/pages/user_list_page.dart';
import 'package:solviolin_common/pages/user_register_page.dart';
import 'package:solviolin_common/pages/user_search_page.dart';
import 'package:solviolin_common/pages/user_update_page.dart';
import 'package:solviolin_common/providers/client_state/auth_state_provider.dart';
import 'package:solviolin_common/providers/is_sign_in_provider.dart';
import 'package:solviolin_common/providers/profile_provider.dart';

part 'router_provider.g.dart';

@riverpod
GoRouter router(Ref ref) {
  final router = GoRouter(
    redirect: (context, state) async {
      final isSignedIn = await ref.read(isSignedInProvider.future);
      if (!isSignedIn) {
        return "/sign-in";
      }

      final prefix = state.uri.pathSegments.firstOrNull ?? "";
      final routeType = prefix.toUserType();

      final profile = await ref.read(profileProvider.future);
      if (routeType != null && routeType != profile.userType) {
        // unauthorized route

        await ref.read(authStateProvider.notifier).signOut();
        return "/sign-in";
      }

      return null;
    },
    routes: [
      GoRoute(
        path: "/",
        redirect: (context, state) async {
          final profile = await ref.read(profileProvider.future);
          final prefix = profile.userType.name;
          return "/$prefix";
        },
      ),
      GoRoute(
        path: "/sign-in",
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: "/check-in",
        builder: (context, state) => const CheckInPage(),
      ),
      GoRoute(
        path: "/metronome",
        builder: (context, state) => const MetronomePage(),
      ),
      GoRoute(
        path: "/student",
        builder: (context, state) => const StudentMenuPage(),
        routes: [
          GoRoute(
            path: "/personal",
            builder: (context, state) => const StudentPersonalPage(),
          ),
          GoRoute(
            path: "/make-up",
            builder: (context, state) => const StudentMakeUpPage(),
          ),
        ],
      ),
      GoRoute(
        path: "/teacher",
        builder: (context, state) => const TeacherMenuPage(),
        routes: [
          GoRoute(
            path: "/reservation",
            builder: (context, state) =>
                const ReservationSlotPage(isForTeacher: true),
          ),
          GoRoute(
            path: "/canceled",
            builder: (context, state) => const CanceledListPage(),
          ),
          GoRoute(
            path: "/control",
            builder: (context, state) =>
                const ControlListPage(isForTeacher: true),
          ),
        ],
      ),
      GoRoute(
        path: "/admin",
        builder: (context, state) => const AdminMenuPage(),
        routes: [
          // branch
          GoRoute(
            path: "/branches",
            builder: (context, state) => const BranchListPage(),
          ),
          GoRoute(
            path: "/branch/select",
            builder: (context, state) => const BranchSelectPage(),
          ),
          GoRoute(
            path: "/branch/register",
            builder: (context, state) => const BranchRegisterPage(),
          ),

          // canceled
          GoRoute(
            path: "/canceled/search",
            builder: (context, state) => const CanceledSearchPage(),
            routes: [
              GoRoute(
                path: "/result",
                builder: (context, state) => const CanceledListPage(),
                routes: [
                  GoRoute(
                    path: "/:canceledID",
                    builder: (context, state) {
                      final canceledID = state.pathParameters["canceledID"]!;
                      return CanceledMadeUpPage(
                        canceledID: int.parse(canceledID),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          // check-in
          GoRoute(
            path: "/check-in/search",
            builder: (context, state) => const CheckInSearchPage(),
            routes: [
              GoRoute(
                path: "/result",
                builder: (context, state) => const CheckInListPage(),
              ),
            ],
          ),

          // control
          GoRoute(
            path: "/control/search",
            builder: (context, state) => const ControlSearchPage(),
            routes: [
              GoRoute(
                path: "/result",
                builder: (context, state) => const ControlListPage(),
              ),
            ],
          ),
          GoRoute(
            path: "/control/register",
            builder: (context, state) => const ControlRegisterPage(),
          ),

          // credit
          GoRoute(
            path: "/credit/initialize",
            builder: (context, state) => const CreditInitializePage(),
          ),

          // dow
          GoRoute(
            path: "/dow/select",
            builder: (context, state) => const DowSelectPage(),
          ),

          // ledger
          GoRoute(
            path: "/ledger/search",
            builder: (context, state) => const LedgerSearchPage(),
            routes: [
              GoRoute(
                path: "/result",
                builder: (context, state) => const LedgerListPage(),
              ),
            ],
          ),
          GoRoute(
            path: "/ledger/create",
            builder: (context, state) {
              final queries = state.uri.queryParameters;
              final branchName = queries["branchName"];
              final userID = queries["userID"];
              return LedgerCreatePage(branchName: branchName, userID: userID);
            },
          ),
          GoRoute(
            path: "/ledger/total",
            builder: (context, state) => const LedgerTotalPage(),
          ),

          // reservation
          GoRoute(
            path: "/reservation",
            builder: (context, state) => const ReservationSlotPage(),
            routes: [
              GoRoute(
                path: "/search",
                builder: (context, state) => const ReservationSearchPage(),
              ),
              GoRoute(
                path: "/create",
                builder: (context, state) {
                  final extra = state.extra! as Map<String, dynamic>;
                  final teacherID = extra["teacherID"] as String;
                  final startDate = extra["startDate"] as DateTime;
                  return ReservationCreatePage(
                    teacherID: teacherID,
                    startDate: startDate,
                  );
                },
              ),
              GoRoute(
                path: "/:reservationID",
                builder: (context, state) {
                  final reservationID = state.pathParameters["reservationID"]!;
                  return ReservationDetailPage(
                    reservationID: int.parse(reservationID),
                  );
                },
              ),
            ],
          ),

          // salary
          GoRoute(
            path: "/salary/search",
            builder: (context, state) => const SalarySearchPage(),
            routes: [
              GoRoute(
                path: "/result",
                builder: (context, state) => const SalaryListPage(),
              ),
            ],
          ),

          // teacher
          GoRoute(
            path: "/teacher/search",
            builder: (context, state) => const TeacherSearchPage(),
            routes: [
              GoRoute(
                path: "/result",
                builder: (context, state) => const TeacherListPage(),
              ),
            ],
          ),
          GoRoute(
            path: "/teacher/select",
            builder: (context, state) {
              final branchName = state.uri.queryParameters["branchName"];
              return TeacherIDSelectPage(branchName: branchName ?? "");
            },
          ),
          GoRoute(
            path: "/teacher/register",
            builder: (context, state) => const TeacherRegisterPage(),
          ),

          // term
          GoRoute(
            path: "/terms",
            builder: (context, state) => const TermListPage(),
            routes: [
              GoRoute(
                path: "/:id/update",
                builder: (context, state) {
                  final id = state.pathParameters["id"]!;
                  return TermUpdatePage(int.parse(id));
                },
              ),
            ],
          ),
          GoRoute(
            path: "/term/register",
            builder: (context, state) => const TermRegisterPage(),
          ),
          GoRoute(
            path: "/term/select",
            builder: (context, state) => const TermSelectPage(),
          ),
          GoRoute(
            path: "/term/extend/branch",
            builder: (context, state) => const TermExtendBranchPage(),
          ),
          GoRoute(
            path: "/term/extend/student",
            builder: (context, state) => const TermExtendStudentPage(),
          ),

          // user
          GoRoute(
            path: "/user/search",
            builder: (context, state) => const UserSearchPage(),
            routes: [
              GoRoute(
                path: "/result",
                builder: (context, state) => const UserListPage(),
                routes: [
                  GoRoute(
                    path: "/:userID",
                    builder: (context, state) {
                      final userID = state.pathParameters["userID"]!;
                      return UserDetailPage(userID: userID);
                    },
                    routes: [
                      GoRoute(
                        path: "/update",
                        builder: (context, state) {
                          final userID = state.pathParameters["userID"]!;
                          return UserUpdatePage(userID: userID);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: "/user/register",
            builder: (context, state) => const UserRegisterPage(),
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);

  return router;
}
