'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import clsx from 'clsx';

const Links = [
  { href: '/popular', label: 'Popular' },
  { href: '/now-playing', label: 'Now Playing' },
  { href: '/top-rated', label: 'Top Rated' },
  { href: '/my-favorites', label: 'My Favorites' }
];

const Header = () => {
  const pathname = usePathname();

  return (
    <header className="w-full backdrop-blur-md bg-black/60 shadow-md border-b border-white/10 sticky top-0 z-50">
      <div className="max-w-7xl mx-auto flex items-center justify-between px-6 py-4">
        <Link
          href="/"
          className="text-2xl font-extrabold text-white tracking-tight hover:text-red-500 transition-colors duration-300"
        >
          Alexis&apos; Movies App
        </Link>

        <nav className="flex flex-wrap gap-4 md:gap-6">
          {Links.map(({ href, label }) => (
            <Link
              key={href}
              href={href}
              className={clsx(
                "text-sm md:text-base font-medium transition-all duration-200 px-2 py-1 rounded-md",
                pathname === href
                  ? "text-white bg-gradient-to-r from-red-600 to-pink-500 shadow-md" : "text-gray-300 hover:text-white hover:bg-white/10"
              )}
            >
              {label}
            </Link>
          ))}
        </nav>
      </div>
    </header>
  );
};

export default Header;
