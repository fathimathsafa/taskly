import 'package:flutter/material.dart';
import '../../task_listing_screen/controller/task_listing_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_textstyles.dart';

class TaskAddingController extends ChangeNotifier {
  String _title = '';
  String _description = '';
  String _priority = 'medium';
  String _status = 'pending';
  String _assignee = 'Fathima Nasrin V K';
  DateTime? _dueDate = DateTime.now().add(const Duration(days: 3));

  // Validation Error Strings (Null means valid)
  String? _titleError;
  String? _descriptionError;
  String? _priorityError;
  String? _statusError;
  String? _assigneeError;
  String? _dueDateError;

  bool _isSubmitting = false;

  // Getters
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

  // Field Setters with Real-time Validation
  void setTitle(String val) {
    _title = val;
    validateTitle();
    notifyListeners();
  }

  void setDescription(String val) {
    _description = val;
    validateDescription();
    notifyListeners();
  }

  void setPriority(String val) {
    _priority = val;
    validatePriority();
    notifyListeners();
  }

  void setStatus(String val) {
    _status = val;
    validateStatus();
    notifyListeners();
  }

  void setAssignee(String val) {
    _assignee = val;
    validateAssignee();
    notifyListeners();
  }

  void setDueDate(DateTime? date) {
    _dueDate = date;
    validateDueDate();
    notifyListeners();
  }

  // Individual Validators
  bool validateTitle() {
    final trimmed = _title.trim();
    if (trimmed.isEmpty) {
      _titleError = 'Task title is required';
      return false;
    } else if (trimmed.length < 3) {
      _titleError = 'Title must be at least 3 characters long';
      return false;
    } else if (trimmed.length > 60) {
      _titleError = 'Title cannot exceed 60 characters (Current: ${trimmed.length})';
      return false;
    }
    _titleError = null;
    return true;
  }

  bool validateDescription() {
    final trimmed = _description.trim();
    if (trimmed.isEmpty) {
      _descriptionError = 'Task description is required';
      return false;
    } else if (trimmed.length < 10) {
      _descriptionError = 'Description must be at least 10 characters long';
      return false;
    } else if (trimmed.length > 500) {
      _descriptionError = 'Description cannot exceed 500 characters (Current: ${trimmed.length})';
      return false;
    }
    _descriptionError = null;
    return true;
  }

  bool validatePriority() {
    if (_priority.isEmpty) {
      _priorityError = 'Priority selection is required';
      return false;
    }
    _priorityError = null;
    return true;
  }

  bool validateStatus() {
    if (_status.isEmpty) {
      _statusError = 'Initial status is required';
      return false;
    }
    _statusError = null;
    return true;
  }

  bool validateAssignee() {
    final trimmed = _assignee.trim();
    if (trimmed.isEmpty) {
      _assigneeError = 'Assigned user is required';
      return false;
    } else if (trimmed.length < 3) {
      _assigneeError = 'Assignee name must be at least 3 characters long';
      return false;
    }
    _assigneeError = null;
    return true;
  }

  bool validateDueDate() {
    if (_dueDate == null) {
      _dueDateError = 'Due date selection is required';
      return false;
    }
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDate = DateTime(_dueDate!.year, _dueDate!.month, _dueDate!.day);
    
    if (selectedDate.isBefore(today)) {
      _dueDateError = 'Due date cannot be in the past';
      return false;
    }
    _dueDateError = null;
    return true;
  }

  // Validate All Fields
  bool validateAll() {
    final v1 = validateTitle();
    final v2 = validateDescription();
    final v3 = validatePriority();
    final v4 = validateStatus();
    final v5 = validateAssignee();
    final v6 = validateDueDate();

    notifyListeners();
    return v1 && v2 && v3 && v4 && v5 && v6;
  }

  // Submit Form Action
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
              Text(
                'Please fix form validation errors before saving.',
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
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

    // Simulate network saving delay
    await Future.delayed(const Duration(milliseconds: 600));

    // Save Task to Controller
    taskListingController.addTask(
      title: _title,
      description: _description,
      priority: _priority,
      status: _status,
      assignee: _assignee,
      dueDate: _dueDate,
      project: '{SW} Taskly Portal',
    );

    _isSubmitting = false;
    notifyListeners();

    // Show Success Toast/Message
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
                    Text('Navigating to Task List...', style: AppTextStyles.caption.copyWith(color: Colors.white70)),
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

      // Reset form
      resetForm();

      // Navigate to Task Listing Screen
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/task-list',
        (route) => route.settings.name == '/dashboard' || route.isFirst,
      );
    }
  }

  void resetForm() {
    _title = '';
    _description = '';
    _priority = 'medium';
    _status = 'pending';
    _assignee = 'Fathima Nasrin V K';
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
