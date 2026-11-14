<?php
declare(strict_types=1);

namespace ShamsDev\BurgundyTheme;

use WP_Query;

if (!defined('ABSPATH')) {
    exit; // Exit if accessed directly
}

/**
 * Class BurgundyWordPressManager
 * Integrates theme assets with WordPress lifecycle hooks.
 */
class BurgundyWordPressManager {
    private const THEME_VERSION = '1.0.0';
    private string $accentHex;

    public function __construct(string $accentHex = '#702D45') {
        $this->accentHex = $accentHex;
        add_action('wp_enqueue_scripts', [$this, 'enqueueBurgundyAssets']);
        add_filter('body_class', [$this, 'injectBurgundyBodyClass']);
    }

    public function enqueueBurgundyAssets(): void {
        wp_enqueue_style(
            'burgundy-pro-style',
            get_template_directory_uri() . '/dist/theme.css',
            [],
            self::THEME_VERSION
        );
    }

    public function injectBurgundyBodyClass(array $classes): array {
        $classes[] = 'shams-dev-burgundy-pro';
        return $classes;
    }
}
