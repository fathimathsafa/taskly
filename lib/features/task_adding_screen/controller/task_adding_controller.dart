import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_textstyles.dart';
import '../../dashboard_screen/controller/dash_board_controller.dart';
import '../../task_listing_screen/controller/task_listing_controller.dart';
import '../service/task_adding_service.dart';

class TaskAddingController extends ChangeNotifier {
  final TaskAddingService _service;

  TaskAddingController({TaskAddingService? service})
      : _service = service ?? TaskAddingService();

  String _title = '';
  String _description = '';
  String _priority = 'medium';
  String _status = 'pending';
  String _assignee = 'Admin User';
  DateTime? _dueDate = DateTime.now().add(const Duration(days: 3));

  String? _titleError;
  String? _descriptionError;
  String? _priorityError;
  String? _statusError;
  String? _assigneeError;
  String? _dueDateError;

  bool _isSubmitting = false;

  String get title => _title;
  String get description => _description;
  String get priority => _priority;
  String get status => _status;
  String get assignee => _assignee;
  DateTime? get dueDate => _dueDate;

  String? get titleError => _titleError;
  String? get descriptionError => _descriptionError;
  String? get priorityError => _priorityError;
  String? get statusError => _statusError;
  String? get assigneeError => _assigneeError;
  String? get dueDateError => _dueDateError;

  bool get isSubmitting => _isSubmitting;

  void setTitle(String val) {
    _title = val;
    _titleError = _service.validateTitle(val);
    notifyListeners();
  }

  void setDescription(String val) {
    _description = val;
    _descriptionError = _service.validateDescription(val);
    notifyListeners();
  }

  void setPriority(String val) {
    _priority = val;
    _priorityError = null;
    notifyListeners();
  }

  void setStatus(String val) {
    _status = val;
    _statusError = null;
    notifyListeners();
  }

  void setAssignee(String val) {
    _assignee = val;
    _assigneeError = _service.validateAssignee(val);
    notifyListeners();
  }

  void setDueDate(DateTime? date) {
    _dueDate = date;
    _dueDateError = _service.validateDueDate(date);
    notifyListeners();
  }

  bool validateAll() {
    _titleError = _service.validateTitle(_title);
    _descriptionError = _service.validateDescription(_description);
    _assigneeError = _service.validateAssignee(_assignee);
    _dueDateError = _service.validateDueDate(_dueDate);

    notifyListeners();
    return _titleError == null &&
        _descriptionError == null &&
        _assigneeError == null &&
        _dueDateError == null;
  }

  Future<void> submitForm(
    BuildContext context,
    TaskListingController taskListingController,
  ) async {
    if (!validateAll()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Please fix form validation errors before saving.',
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    _isSubmitting = true;
    notifyListeners();

    try {
      await _service.addNewTask(
        title: _title,
        description: _description,
        status: _status,
        priority: _priority,
        dueDate: _dueDate!,
        assignee: _assignee,
      );

      taskListingController.loadTasks();
      if (context.mounted) {
        try {
          context.read<DashboardController>().loadTasks();
        } catch (_) {}
      }

      _isSubmitting = false;
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Task Created Successfully!', style: AppTextStyles.subtitle.copyWith(color: Colors.white)),
                      Text('Saved to local storage', style: AppTextStyles.caption.copyWith(color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );

        resetForm();

        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.taskList,
          (route) => route.settings.name == AppRoutes.dashboard || route.isFirst,
        );
      }
    } catch (e) {
      _isSubmitting = false;
      notifyListeners();

      final errorMsg = e is AppException ? e.message : 'Failed to save task: ${e.toString()}';

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline_rounded, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(errorMsg, style: AppTextStyles.bodyMedium.copyWith(color: Colors.white)),
                ),
              ],
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  void resetForm() {
    _title = '';
    _description = '';
    _priority = 'medium';
    _status = 'pending';
    _assignee = 'Admin User';
    _dueDate = DateTime.now().add(const Duration(days: 3));

    _titleError = null;
    _descriptionError = null;
    _priorityError = null;
    _statusError = null;
    _assigneeError = null;
    _dueDateError = null;
    _isSubmitting = false;

    notifyListeners();
  }
}
