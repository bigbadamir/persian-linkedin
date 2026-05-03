import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

void main() {
  runApp(const PersianLinkedInApp());
}

class PersianLinkedInApp extends StatefulWidget {
  const PersianLinkedInApp({super.key});

  @override
  State<PersianLinkedInApp> createState() => _PersianLinkedInAppState();
}

class _PersianLinkedInAppState extends State<PersianLinkedInApp> {
  bool isDarkMode = true;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF4F8FB),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF229ED9),
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.vazirmatnTextTheme(),
    );

    final darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF07111F),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF229ED9),
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.vazirmatnTextTheme(ThemeData.dark().textTheme),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'حرفه‌ای‌ها',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: MainShell(
          isDarkMode: isDarkMode,
          onToggleTheme: toggleTheme,
        ),
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const MainShell({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int selectedIndex = 0;

  final List<AppNavItem> navItems = const [
    AppNavItem(title: 'خانه', icon: LucideIcons.home),
    AppNavItem(title: 'شبکه', icon: LucideIcons.users),
    AppNavItem(title: 'پست', icon: LucideIcons.plusCircle),
    AppNavItem(title: 'شغل‌ها', icon: LucideIcons.briefcase),
    AppNavItem(title: 'پیام‌ها', icon: LucideIcons.messageCircle),
    AppNavItem(title: 'پروفایل', icon: LucideIcons.user),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        isDarkMode: widget.isDarkMode,
        onToggleTheme: widget.onToggleTheme,
      ),
      const NetworkPage(),
      const CreatePostPage(),
      const JobsPage(),
      const MessagesPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          const AppBackground(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 920;

                if (isWide) {
                  return Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: AppSideNav(
                          items: navItems,
                          selectedIndex: selectedIndex,
                          onSelect: (index) {
                            setState(() => selectedIndex = index);
                          },
                        ),
                      ),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 240),
                          child: KeyedSubtree(
                            key: ValueKey(selectedIndex),
                            child: pages[selectedIndex],
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 240),
                        child: KeyedSubtree(
                          key: ValueKey(selectedIndex),
                          child: pages[selectedIndex],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      child: AppBottomNav(
                        items: navItems,
                        selectedIndex: selectedIndex,
                        onSelect: (index) {
                          setState(() => selectedIndex = index);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AppNavItem {
  final String title;
  final IconData icon;

  const AppNavItem({
    required this.title,
    required this.icon,
  });
}

class AppBackground extends StatelessWidget {
  const AppBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? const [
                  Color(0xFF07111F),
                  Color(0xFF0A2342),
                  Color(0xFF081522),
                ]
              : const [
                  Color(0xFFF4F8FB),
                  Color(0xFFDFF4FF),
                  Color(0xFFFFFFFF),
                ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -90,
            right: -70,
            child: SoftCircle(
              size: 260,
              color: const Color(0xFF229ED9).withOpacity(isDark ? 0.28 : 0.22),
            ),
          ),
          Positioned(
            bottom: -110,
            left: -80,
            child: SoftCircle(
              size: 300,
              color: const Color(0xFF6ED6FF).withOpacity(isDark ? 0.18 : 0.28),
            ),
          ),
          Positioned(
            top: 240,
            left: 40,
            child: SoftCircle(
              size: 130,
              color: Colors.white.withOpacity(isDark ? 0.04 : 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class SoftCircle extends StatelessWidget {
  final double size;
  final Color color;

  const SoftCircle({
    super.key,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 90,
            spreadRadius: 30,
          ),
        ],
      ),
    );
  }
}

class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.radius = 28,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.09)
            : Colors.white.withOpacity(0.72),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.13)
              : Colors.white.withOpacity(0.86),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.22 : 0.08),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: child,
    );
  }
}

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 46,
          width: 46,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF229ED9),
                Color(0xFF6ED6FF),
              ],
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF229ED9).withOpacity(0.32),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: const Icon(
            LucideIcons.link,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'حرفه‌ای‌ها',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 17,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'شبکه کاری فارسی',
                style: TextStyle(
                  color: Color(0xFF229ED9),
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AppSideNav extends StatelessWidget {
  final List<AppNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const AppSideNav({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 32,
      padding: const EdgeInsets.all(14),
      child: SizedBox(
        width: 224,
        child: Column(
          children: [
            const SizedBox(height: 8),
            const AppLogo(),
            const SizedBox(height: 26),
            ...List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = selectedIndex == index;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: NavButton(
                  title: item.title,
                  icon: item.icon,
                  selected: isSelected,
                  horizontal: true,
                  onTap: () => onSelect(index),
                ),
              );
            }),
            const Spacer(),
            Text(
              'نسخه اولیه محصول',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.color
                    ?.withOpacity(0.55),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class AppBottomNav extends StatelessWidget {
  final List<AppNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const AppBottomNav({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 28,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];

          return Expanded(
            child: NavButton(
              title: item.title,
              icon: item.icon,
              selected: selectedIndex == index,
              horizontal: false,
              onTap: () => onSelect(index),
            ),
          );
        }),
      ),
    );
  }
}

class NavButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final bool horizontal;
  final VoidCallback onTap;

  const NavButton({
    super.key,
    required this.title,
    required this.icon,
    required this.selected,
    required this.horizontal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selectedColor = const Color(0xFF229ED9);
    final normalColor =
        Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.66);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: horizontal
            ? const EdgeInsets.symmetric(horizontal: 14, vertical: 13)
            : const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? selectedColor.withOpacity(0.16) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: horizontal
            ? Row(
                children: [
                  Icon(icon, color: selected ? selectedColor : normalColor),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(
                      color: selected ? selectedColor : normalColor,
                      fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 21,
                    color: selected ? selectedColor : normalColor,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selected ? selectedColor : normalColor,
                      fontSize: 10.5,
                      fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class PageFrame extends StatelessWidget {
  final Widget child;

  const PageFrame({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 112),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1160),
          child: child,
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const HomePage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: AppLogo()),
              IconButton.filledTonal(
                onPressed: onToggleTheme,
                icon: Icon(
                  isDarkMode ? LucideIcons.sun : LucideIcons.moon,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const HeroCard(),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 760;

              if (isWide) {
                return const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 7,
                      child: FeedColumn(),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 4,
                      child: SidebarColumn(),
                    ),
                  ],
                );
              }

              return const Column(
                children: [
                  FeedColumn(),
                  SizedBox(height: 16),
                  SidebarColumn(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class HeroCard extends StatelessWidget {
  const HeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppBadge(text: 'نسخه اولیه محصول'),
          const SizedBox(height: 14),
          Text(
            'شبکه اجتماعی حرفه‌ای فارسی برای برند شخصی، استخدام و ارتباطات کاری',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 1.45,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'اینجا قرار است پروفایل حرفه‌ای بسازی، پست منتشر کنی، با آدم‌های مرتبط وصل شوی، فرصت‌های شغلی ببینی و مسیر رشد کاری خودت را بسازی.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.85,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.72),
                ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              AppPrimaryButton(
                icon: LucideIcons.userPlus,
                text: 'ساخت پروفایل',
                onTap: () {},
              ),
              AppSecondaryButton(
                icon: LucideIcons.search,
                text: 'جستجوی فرصت‌ها',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AppBadge extends StatelessWidget {
  final String text;

  const AppBadge({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF229ED9).withOpacity(0.13),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: const Color(0xFF229ED9).withOpacity(0.24),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF229ED9),
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}

class AppPrimaryButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const AppPrimaryButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 19),
      label: Text(text),
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF229ED9),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}

class AppSecondaryButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const AppSecondaryButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 19),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        side: BorderSide(
          color: const Color(0xFF229ED9).withOpacity(0.42),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}

class FeedColumn extends StatelessWidget {
  const FeedColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CreatePostCard(),
        SizedBox(height: 16),
        PostCard(
          name: 'آرمان رضایی',
          role: 'مدیر محصول در استارتاپ مالی',
          text:
              'برای ساختن یک شبکه حرفه‌ای فارسی، فقط کپی کردن لینکدین کافی نیست. باید رفتار بازار، اعتماد، رزومه فارسی، استخدام و شبکه‌سازی واقعی را با هم دید.',
          tag: 'محصول',
          likes: 248,
          comments: 36,
        ),
        SizedBox(height: 16),
        PostCard(
          name: 'سارا احمدی',
          role: 'متخصص منابع انسانی',
          text:
              'به‌نظرم یکی از مهم‌ترین فیچرها برای کارجوها این است که دقیقاً بدانند درخواست شغلی‌شان در چه مرحله‌ای است.',
          tag: 'استخدام',
          likes: 179,
          comments: 22,
        ),
      ],
    );
  }
}

class CreatePostCard extends StatelessWidget {
  const CreatePostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Column(
        children: [
          Row(
            children: [
              const AppAvatar(name: 'شما'),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surface
                        .withOpacity(0.34),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.07),
                    ),
                  ),
                  child: Text(
                    'امروز چه تجربه حرفه‌ای‌ای داری؟',
                    style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withOpacity(0.56),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Row(
            children: [
              MiniAction(icon: LucideIcons.image, text: 'تصویر'),
              SizedBox(width: 10),
              MiniAction(icon: LucideIcons.fileText, text: 'مقاله'),
              SizedBox(width: 10),
              MiniAction(icon: LucideIcons.briefcase, text: 'فرصت شغلی'),
            ],
          ),
        ],
      ),
    );
  }
}

class MiniAction extends StatelessWidget {
  final IconData icon;
  final String text;

  const MiniAction({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF229ED9).withOpacity(0.09),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF229ED9), size: 18),
            const SizedBox(width: 6),
            Text(
              text,
              style: const TextStyle(
                color: Color(0xFF229ED9),
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final String name;
  final String role;
  final String text;
  final String tag;
  final int likes;
  final int comments;

  const PostCard({
    super.key,
    required this.name,
    required this.role,
    required this.text,
    required this.tag,
    required this.likes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAvatar(name: name),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      role,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withOpacity(0.62),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(LucideIcons.moreHorizontal),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.85,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 14),
          AppBadge(text: '#$tag'),
          const SizedBox(height: 14),
          Divider(
            color: Theme.of(context).dividerColor.withOpacity(0.18),
          ),
          Row(
            children: [
              PostAction(
                icon: LucideIcons.thumbsUp,
                text: '$likes پسند',
              ),
              const SizedBox(width: 16),
              PostAction(
                icon: LucideIcons.messageCircle,
                text: '$comments نظر',
              ),
              const Spacer(),
              const PostAction(
                icon: LucideIcons.bookmark,
                text: 'ذخیره',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PostAction extends StatelessWidget {
  final IconData icon;
  final String text;

  const PostAction({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.62);

    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class AppAvatar extends StatelessWidget {
  final String name;

  const AppAvatar({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final cleanName = name.trim();
    final firstLetter = cleanName.isEmpty ? '؟' : cleanName.substring(0, 1);

    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF229ED9),
            Color(0xFF6ED6FF),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        firstLetter,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 18,
        ),
      ),
    );
  }
}

class SidebarColumn extends StatelessWidget {
  const SidebarColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ProfileStatusCard(),
        SizedBox(height: 16),
        JobSuggestionsCard(),
        SizedBox(height: 16),
        PeopleSuggestionsCard(),
      ],
    );
  }
}

class ProfileStatusCard extends StatelessWidget {
  const ProfileStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'وضعیت پروفایل',
            icon: LucideIcons.activity,
          ),
          const SizedBox(height: 16),
          const LinearProgressIndicator(
            value: 0.62,
            minHeight: 9,
            borderRadius: BorderRadius.all(Radius.circular(999)),
            color: Color(0xFF229ED9),
          ),
          const SizedBox(height: 10),
          Text(
            '۶۲٪ کامل شده',
            style: TextStyle(
              color:
                  Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          const ProfileTip(text: 'افزودن تجربه کاری'),
          const ProfileTip(text: 'افزودن مهارت‌های اصلی'),
          const ProfileTip(text: 'آپلود رزومه'),
        ],
      ),
    );
  }
}

class ProfileTip extends StatelessWidget {
  final String text;

  const ProfileTip({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 9),
      child: Row(
        children: [
          const Icon(
            LucideIcons.checkCircle2,
            color: Color(0xFF229ED9),
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class JobSuggestionsCard extends StatelessWidget {
  const JobSuggestionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: 'فرصت‌های پیشنهادی',
            icon: LucideIcons.briefcase,
          ),
          SizedBox(height: 14),
          SmallJobItem(
            title: 'مدیر دیجیتال مارکتینگ',
            company: 'شرکت فناوری آبی',
            match: '۸۷٪ تطابق',
          ),
          SmallJobItem(
            title: 'Product Manager',
            company: 'استارتاپ مالی',
            match: '۷۴٪ تطابق',
          ),
        ],
      ),
    );
  }
}

class SmallJobItem extends StatelessWidget {
  final String title;
  final String company;
  final String match;

  const SmallJobItem({
    super.key,
    required this.title,
    required this.company,
    required this.match,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFF229ED9).withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(
            LucideIcons.building2,
            color: Color(0xFF229ED9),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  company,
                  style: TextStyle(
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withOpacity(0.62),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            match,
            style: const TextStyle(
              color: Color(0xFF229ED9),
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class PeopleSuggestionsCard extends StatelessWidget {
  const PeopleSuggestionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: 'افراد پیشنهادی',
            icon: LucideIcons.users,
          ),
          SizedBox(height: 14),
          PersonRow(
            name: 'نیما محمدی',
            role: 'طراح محصول',
          ),
          PersonRow(
            name: 'الهام کریمی',
            role: 'کارشناس منابع انسانی',
          ),
          PersonRow(
            name: 'کاوه شریفی',
            role: 'توسعه‌دهنده Flutter',
          ),
        ],
      ),
    );
  }
}

class PersonRow extends StatelessWidget {
  final String name;
  final String role;

  const PersonRow({
    super.key,
    required this.name,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          AppAvatar(name: name),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 3),
                Text(
                  role,
                  style: TextStyle(
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withOpacity(0.62),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: const Color(0xFF229ED9).withOpacity(0.42),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('ارتباط'),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const SectionTitle({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF229ED9)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 17,
          ),
        ),
      ],
    );
  }
}

class NetworkPage extends StatelessWidget {
  const NetworkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      icon: LucideIcons.users,
      title: 'شبکه من',
      description:
          'اینجا درخواست‌های ارتباط، افراد پیشنهادی، دنبال‌کننده‌ها و ارتباطات حرفه‌ای کاربر را می‌سازیم.',
    );
  }
}

class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      icon: LucideIcons.plusCircle,
      title: 'انتشار پست',
      description:
          'در این بخش ادیتور پست، آپلود تصویر، ویدیو، فایل، هشتگ، منشن و زمان‌بندی انتشار را اضافه می‌کنیم.',
    );
  }
}

class JobsPage extends StatelessWidget {
  const JobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      icon: LucideIcons.briefcase,
      title: 'فرصت‌های شغلی',
      description:
          'اینجا جستجوی شغل، درخواست شغلی، آگهی‌های پیشنهادی و پنل کارفرما را مرحله‌به‌مرحله می‌سازیم.',
    );
  }
}

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      icon: LucideIcons.messageCircle,
      title: 'پیام‌ها',
      description:
          'در این بخش پیام‌رسان داخلی، درخواست پیام، ارسال رزومه، ارسال فایل و چت کاری را پیاده‌سازی می‌کنیم.',
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 850;

          if (isWide) {
            return const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 7,
                  child: Column(
                    children: [
                      ProfileHeaderCard(),
                      SizedBox(height: 16),
                      AboutMeCard(),
                      SizedBox(height: 16),
                      ExperienceCard(),
                      SizedBox(height: 16),
                      PortfolioCard(),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      ProfileCompletionCard(),
                      SizedBox(height: 16),
                      SkillsCard(),
                      SizedBox(height: 16),
                      ProfileStatsCard(),
                    ],
                  ),
                ),
              ],
            );
          }

          return const Column(
            children: [
              ProfileHeaderCard(),
              SizedBox(height: 16),
              ProfileCompletionCard(),
              SizedBox(height: 16),
              AboutMeCard(),
              SizedBox(height: 16),
              SkillsCard(),
              SizedBox(height: 16),
              ExperienceCard(),
              SizedBox(height: 16),
              PortfolioCard(),
              SizedBox(height: 16),
              ProfileStatsCard(),
            ],
          );
        },
      ),
    );
  }
}

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(28),
              ),
              gradient: LinearGradient(
                colors: [
                  Color(0xFF229ED9),
                  Color(0xFF0A2342),
                  Color(0xFF6ED6FF),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 22,
                  top: 22,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.28),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.badgeCheck,
                          color: Colors.white,
                          size: 17,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'پروفایل تأیید شده',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.translate(
                  offset: const Offset(0, -38),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 104,
                        height: 104,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(34),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF229ED9),
                              Color(0xFF6ED6FF),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF229ED9).withOpacity(0.32),
                              blurRadius: 28,
                              offset: const Offset(0, 14),
                            ),
                          ],
                        ),
                        child: const Text(
                          'ا',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.end,
                            children: [
                              AppPrimaryButton(
                                icon: LucideIcons.edit3,
                                text: 'ویرایش پروفایل',
                                onTap: () {},
                              ),
                              AppSecondaryButton(
                                icon: LucideIcons.fileDown,
                                text: 'دریافت رزومه',
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'امیرحسین ولی',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w900,
                                ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'مدیر کمپین و متخصص دیجیتال مارکتینگ',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: const Color(0xFF229ED9),
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'تهران، ایران · آماده همکاری پروژه‌ای و تمام‌وقت',
                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color
                              ?.withOpacity(0.68),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: const [
                          AppBadge(text: 'آماده همکاری'),
                          AppBadge(text: 'دیجیتال مارکتینگ'),
                          AppBadge(text: 'کمپین'),
                          AppBadge(text: 'محتوا'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileCompletionCard extends StatelessWidget {
  const ProfileCompletionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'تکمیل پروفایل',
            icon: LucideIcons.gauge,
          ),
          const SizedBox(height: 16),
          const LinearProgressIndicator(
            value: 0.74,
            minHeight: 10,
            borderRadius: BorderRadius.all(Radius.circular(999)),
            color: Color(0xFF229ED9),
          ),
          const SizedBox(height: 10),
          const Text(
            '۷۴٪ کامل شده',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Color(0xFF229ED9),
            ),
          ),
          const SizedBox(height: 14),
          const ProfileTip(text: 'افزودن ۲ نمونه‌کار بیشتر'),
          const ProfileTip(text: 'دریافت ۳ تأیید مهارت'),
          const ProfileTip(text: 'نوشتن خلاصه حرفه‌ای کامل‌تر'),
        ],
      ),
    );
  }
}

class AboutMeCard extends StatelessWidget {
  const AboutMeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'درباره من',
            icon: LucideIcons.user,
          ),
          const SizedBox(height: 14),
          Text(
            'من روی طراحی و اجرای کمپین‌های دیجیتال، رشد محصول، تولید محتوا و ساختن روایت برند کار می‌کنم. تجربه کار با برندهای بزرگ، کمپین‌های پرفورمنسی و پروژه‌های محتوایی باعث شده بتوانم بین خلاقیت، داده و نتیجه تجاری تعادل ایجاد کنم.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.9,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.78),
                ),
          ),
        ],
      ),
    );
  }
}

class ExperienceCard extends StatelessWidget {
  const ExperienceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: 'تجربه کاری',
            icon: LucideIcons.briefcase,
          ),
          SizedBox(height: 14),
          ExperienceItem(
            title: 'Campaign Manager',
            company: 'سوپر اپلیکیشن تاپ',
            date: '۱۴۰۲ تا اکنون',
            description:
                'طراحی، اجرا و تحلیل کمپین‌های جذب، نگهداشت و افزایش تراکنش کاربران در محصولات پرداختی و مالی.',
          ),
          Divider(height: 26),
          ExperienceItem(
            title: 'Digital Marketing Specialist',
            company: 'علی‌بابا',
            date: '۱۳۹۹ تا ۱۴۰۱',
            description:
                'همکاری در کمپین‌های دیجیتال، تحلیل رفتار کاربر، تولید محتوا و رشد کانال‌های جذب در حوزه سفر.',
          ),
          Divider(height: 26),
          ExperienceItem(
            title: 'Content Manager',
            company: 'کارو استودیو',
            date: '۱۳۹۷ تا ۱۳۹۹',
            description:
                'مدیریت تولید محتوا، سناریونویسی، ایده‌پردازی و اجرای پروژه‌های خلاقه برای برندها.',
          ),
        ],
      ),
    );
  }
}

class ExperienceItem extends StatelessWidget {
  final String title;
  final String company;
  final String date;
  final String description;

  const ExperienceItem({
    super.key,
    required this.title,
    required this.company,
    required this.date,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFF229ED9).withOpacity(0.13),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            LucideIcons.building2,
            color: Color(0xFF229ED9),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                company,
                style: const TextStyle(
                  color: Color(0xFF229ED9),
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.color
                      ?.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.75,
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withOpacity(0.74),
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SkillsCard extends StatelessWidget {
  const SkillsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final skills = [
      'Campaign Management',
      'Digital Marketing',
      'Content Strategy',
      'Performance Marketing',
      'Brand Storytelling',
      'SEO',
      'Social Media',
      'Marketing Analytics',
    ];

    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'مهارت‌ها',
            icon: LucideIcons.sparkles,
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills
                .map(
                  (skill) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF229ED9).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: const Color(0xFF229ED9).withOpacity(0.18),
                      ),
                    ),
                    child: Text(
                      skill,
                      style: const TextStyle(
                        color: Color(0xFF229ED9),
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class PortfolioCard extends StatelessWidget {
  const PortfolioCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: 'نمونه‌کارها و دستاوردها',
            icon: LucideIcons.image,
          ),
          SizedBox(height: 14),
          PortfolioItem(
            title: 'کمپین افزایش تراکنش کاربران',
            description:
                'طراحی مکانیزم امتیازدهی، مأموریت روزانه، جایزه لحظه‌ای و تحلیل رفتار کاربران برای رشد تراکنش.',
            icon: LucideIcons.trendingUp,
          ),
          SizedBox(height: 10),
          PortfolioItem(
            title: 'استراتژی محتوای شبکه‌های اجتماعی',
            description:
                'طراحی تقویم محتوایی، لحن برند، ایده‌های ویدیویی و ساختار پست‌های تعاملی برای برند.',
            icon: LucideIcons.megaphone,
          ),
          SizedBox(height: 10),
          PortfolioItem(
            title: 'پروپوزال رشد کانال‌های یوتیوب',
            description:
                'تحقیق بازار، انتخاب موضوع، مدل درآمدی، بودجه‌بندی و مسیر رسیدن به درآمد دلاری.',
            icon: LucideIcons.playCircle,
          ),
        ],
      ),
    );
  }
}

class PortfolioItem extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const PortfolioItem({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF229ED9).withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF229ED9).withOpacity(0.12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF229ED9),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        height: 1.75,
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withOpacity(0.68),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileStatsCard extends StatelessWidget {
  const ProfileStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: 'آمار پروفایل',
            icon: LucideIcons.barChart3,
          ),
          SizedBox(height: 14),
          ProfileStatRow(
            title: 'بازدید پروفایل',
            value: '۱۲۸',
            icon: LucideIcons.eye,
          ),
          ProfileStatRow(
            title: 'دنبال‌کننده',
            value: '۲.۴K',
            icon: LucideIcons.users,
          ),
          ProfileStatRow(
            title: 'ارتباطات',
            value: '۸۷۶',
            icon: LucideIcons.network,
          ),
          ProfileStatRow(
            title: 'تأیید مهارت',
            value: '۳۲',
            icon: LucideIcons.badgeCheck,
          ),
        ],
      ),
    );
  }
}

class ProfileStatRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const ProfileStatRow({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.28),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF229ED9),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF229ED9),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class SimplePage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const SimplePage({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppLogo(),
          const SizedBox(height: 18),
          GlassPanel(
            padding: const EdgeInsets.all(26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFF229ED9).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF229ED9),
                    size: 32,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.9,
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withOpacity(0.72),
                      ),
                ),
                const SizedBox(height: 22),
                const AppBadge(text: 'در مراحل بعدی کامل می‌شود'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}