import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'custom_button.dart';

enum ErrorType {
  networkError,
  locationError,
  weatherApiError,
  permissionError,
  generalError,
  noData
}

class CustomErrorWidget extends StatelessWidget {
  final ErrorType errorType;
  final String? customMessage;
  final String? customTitle;
  final VoidCallback? onRetry;
  final VoidCallback? onSettings;
  final bool showRetryButton;
  final EdgeInsetsGeometry? padding;
  final IconData? customIcon;

  const CustomErrorWidget({
    Key? key,
    required this.errorType,
    this.customMessage,
    this.customTitle,
    this.onRetry,
    this.onSettings,
    this.showRetryButton = true,
    this.padding,
    this.customIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: padding ?? const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icône d'erreur
          _buildErrorIcon(theme, isDark),

          const SizedBox(height: 24),

          // Titre d'erreur
          _buildErrorTitle(theme),

          const SizedBox(height: 12),

          // Message d'erreur
          _buildErrorMessage(theme),

          const SizedBox(height: 32),

          // Boutons d'action
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildErrorIcon(ThemeData theme, bool isDark) {
    final icon = customIcon ?? _getErrorIcon();
    final iconColor = _getErrorColor(theme);

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: iconColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Icon(
        icon,
        size: 40,
        color: iconColor,
      ),
    ).animate()
        .scale(delay: const Duration(milliseconds: 100))
        .then()
        .shake(hz: 2, curve: Curves.easeInOut);
  }

  Widget _buildErrorTitle(ThemeData theme) {
    final title = customTitle ?? _getErrorTitle();

    return Text(
      title,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: _getErrorColor(theme),
      ),
      textAlign: TextAlign.center,
    ).animate().fadeIn(delay: const Duration(milliseconds: 200));
  }

  Widget _buildErrorMessage(ThemeData theme) {
    final message = customMessage ?? _getErrorMessage();

    return Text(
      message,
      style: theme.textTheme.bodyLarge?.copyWith(
        height: 1.5,
        color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
      ),
      textAlign: TextAlign.center,
    ).animate().fadeIn(delay: const Duration(milliseconds: 300));
  }

  Widget _buildActionButtons() {
    final buttons = <Widget>[];

    if (showRetryButton && onRetry != null) {
      buttons.add(
        CustomButton(
          text: 'Réessayer',
          icon: Icons.refresh,
          onPressed: onRetry,
          type: ButtonType.primary,
          width: 140,
        ),
      );
    }

    if (onSettings != null && _shouldShowSettingsButton()) {
      buttons.add(
        CustomButton(
          text: 'Paramètres',
          icon: Icons.settings,
          onPressed: onSettings,
          type: ButtonType.outlined,
          width: 140,
        ),
      );
    }

    if (buttons.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: buttons,
    ).animate().fadeIn(delay: const Duration(milliseconds: 400))
        .slideY(begin: 0.3);
  }

  IconData _getErrorIcon() {
    switch (errorType) {
      case ErrorType.networkError:
        return Icons.wifi_off;
      case ErrorType.locationError:
        return Icons.location_off;
      case ErrorType.weatherApiError:
        return Icons.cloud_off;
      case ErrorType.permissionError:
        return Icons.block;
      case ErrorType.noData:
        return Icons.inbox;
      case ErrorType.generalError:
      default:
        return Icons.error_outline;
    }
  }

  String _getErrorTitle() {
    switch (errorType) {
      case ErrorType.networkError:
        return 'Pas de connexion';
      case ErrorType.locationError:
        return 'Erreur de localisation';
      case ErrorType.weatherApiError:
        return 'Service indisponible';
      case ErrorType.permissionError:
        return 'Autorisation requise';
      case ErrorType.noData:
        return 'Aucune donnée';
      case ErrorType.generalError:
      default:
        return 'Une erreur s\'est produite';
    }
  }

  String _getErrorMessage() {
    switch (errorType) {
      case ErrorType.networkError:
        return 'Vérifiez votre connexion internet et réessayez.';
      case ErrorType.locationError:
        return 'Impossible d\'obtenir votre position. Vérifiez les paramètres de localisation.';
      case ErrorType.weatherApiError:
        return 'Le service météo est temporairement indisponible. Veuillez réessayer plus tard.';
      case ErrorType.permissionError:
        return 'L\'application a besoin d\'autorisations pour fonctionner correctement.';
      case ErrorType.noData:
        return 'Aucune donnée météo disponible pour le moment.';
      case ErrorType.generalError:
      default:
        return 'Une erreur inattendue s\'est produite. Veuillez réessayer.';
    }
  }

  Color _getErrorColor(ThemeData theme) {
    switch (errorType) {
      case ErrorType.networkError:
        return Colors.orange;
      case ErrorType.locationError:
        return Colors.blue;
      case ErrorType.weatherApiError:
        return Colors.purple;
      case ErrorType.permissionError:
        return Colors.amber;
      case ErrorType.noData:
        return Colors.grey;
      case ErrorType.generalError:
      default:
        return Colors.red;
    }
  }

  bool _shouldShowSettingsButton() {
    return errorType == ErrorType.locationError ||
        errorType == ErrorType.permissionError;
  }
}

// Widgets d'erreur spécialisés pour l'app météo
class WeatherErrorWidgets {
  static Widget networkError({VoidCallback? onRetry}) {
    return CustomErrorWidget(
      errorType: ErrorType.networkError,
      onRetry: onRetry,
    );
  }

  static Widget locationPermissionError({
    VoidCallback? onRetry,
    VoidCallback? onSettings,
  }) {
    return CustomErrorWidget(
      errorType: ErrorType.permissionError,
      customTitle: 'Localisation désactivée',
      customMessage: 'Activez la localisation pour obtenir la météo de votre région.',
      onRetry: onRetry,
      onSettings: onSettings,
    );
  }

  static Widget weatherServiceError({VoidCallback? onRetry}) {
    return CustomErrorWidget(
      errorType: ErrorType.weatherApiError,
      onRetry: onRetry,
    );
  }

  static Widget noWeatherData({VoidCallback? onRefresh}) {
    return CustomErrorWidget(
      errorType: ErrorType.noData,
      customTitle: 'Aucune donnée météo',
      customMessage: 'Impossible de récupérer les données météo pour cette localisation.',
      onRetry: onRefresh,
      showRetryButton: true,
    );
  }

  static Widget cityNotFound({
    required String cityName,
    VoidCallback? onRetry,
  }) {
    return CustomErrorWidget(
      errorType: ErrorType.noData,
      customTitle: 'Ville introuvable',
      customMessage: 'Aucune donnée météo trouvée pour "$cityName". Vérifiez l\'orthographe.',
      customIcon: Icons.search_off,
      onRetry: onRetry,
    );
  }
}

// Widget d'erreur sous forme de carte
class ErrorCard extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;

  const ErrorCard({
    Key? key,
    required this.title,
    required this.message,
    required this.icon,
    this.onTap,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = color ?? Colors.red;

    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: cardColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: cardColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  icon,
                  color: cardColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: cardColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: cardColor.withOpacity(0.7),
                ),
            ],
          ),
        ),
      ),
    ).animate()
        .fadeIn(delay: const Duration(milliseconds: 100))
        .slideX(begin: 0.3);
  }
}

// Dialog d'erreur personnalisé
class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final List<Widget>? actions;

  const ErrorDialog({
    Key? key,
    required this.title,
    required this.message,
    this.icon,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: Colors.red,
              size: 28,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: theme.textTheme.bodyLarge?.copyWith(
          height: 1.5,
        ),
      ),
      actions: actions ?? [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }

  static Future<void> show(
      BuildContext context, {
        required String title,
        required String message,
        IconData? icon,
        List<Widget>? actions,
      }) {
    return showDialog(
      context: context,
      builder: (context) => ErrorDialog(
        title: title,
        message: message,
        icon: icon,
        actions: actions,
      ),
    );
  }
}