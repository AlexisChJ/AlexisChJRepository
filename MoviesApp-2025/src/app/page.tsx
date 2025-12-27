"use client";

import Image from "next/image";
import Link from "next/link";
import { useEffect, useState } from "react";
import Carrusel from "../components/Carrusel/Carrusel";
import { getTopRatedMovies } from "../services/movies/getTopRated";
import { getPopularMovies } from "../services/movies/getPopularMovies";
import { getNowPlayingMovies } from "@/services/movies/getNowPlaying";
import cine from "../components/ui/cine.jpg";

interface Movie {
  id: number;
  title: string;
  poster_path: string;
}

export default function Home() {
  const [topRated, setTopRated] = useState<Movie[]>([]);
  const [popularMovies, setPopularMovies] = useState<Movie[]>([]);
  const [nowPlayingMovies, setNowPlayingMovies] = useState<Movie[]>([]);


  useEffect(() => {
    const fetchMovies = async () => {
      const topRatedData = await getTopRatedMovies();
      const popularData = await getPopularMovies();
      const nowPlayingData = await getNowPlayingMovies();

      setTopRated(topRatedData.results || []);
      setPopularMovies(popularData.results || []);
      setNowPlayingMovies(nowPlayingData.results || []);
    };

    fetchMovies();
  }, []);

  return (
    <main className="bg-black min-h-screen flex flex-col items-center justify-center px-6 py-20 text-white">
      <h1 className="text-5xl font-extrabold mb-6 text-red-600 drop-shadow-lg text-center">
        Welcome to Alexis&apos; Movie App
      </h1>
      <p className="text-lg max-w-xl text-center text-gray-300 mb-10">
        Discover, explore, and keep track of your favorite movies all in one place.
        Browse popular titles, see what&apos;s now playing, and manage your own favorites list.
      </p>

      <div className="flex flex-wrap justify-center gap-6 mb-12">
        <Link href="/popular" className="bg-red-600 hover:bg-red-700 transition-colors rounded-lg px-8 py-4 font-semibold text-white shadow-lg">Popular Movies</Link>
        <Link href="/now-playing" className="bg-red-600 hover:bg-red-700 transition-colors rounded-lg px-8 py-4 font-semibold text-white shadow-lg">Now Playing</Link>
        <Link href="/top-rated" className="bg-red-600 hover:bg-red-700 transition-colors rounded-lg px-8 py-4 font-semibold text-white shadow-lg">Top Rated</Link>
        <Link href="/my-favorites" className="bg-red-600 hover:bg-red-700 transition-colors rounded-lg px-8 py-4 font-semibold text-white shadow-lg">My Favorites</Link>
      </div>

      <div className="max-w-xl w-full relative rounded-xl overflow-hidden shadow-xl mb-16">
        <Image
          src={cine}
          alt="Movie Theater"
          width={800}
          height={450}
          className="object-cover rounded-xl brightness-75"
          priority
        />
      </div>

      <section className="w-full max-w-6xl mb-12">
        <h2 className="text-3xl font-extrabold mb-6 text-red-600 drop-shadow-lg text-center">Top Rated Movies</h2>
        <Carrusel>
          {topRated.map((movie) => (
            <Link
              key={movie.id}
              href={`/movie/${movie.id}`}
              className="min-w-[200px] flex-shrink-0 hover:scale-105 transition-transform duration-200"
            >
              <Image
                src={`https://image.tmdb.org/t/p/w500${movie.poster_path}`}
                alt={movie.title}
                width={200}
                height={300}
                className="rounded-lg shadow-lg"
              />
              <p className="text-center mt-2">{movie.title}</p>
            </Link>
          ))}
        </Carrusel>
      </section>

      <section className="w-full max-w-6xl mb-12">
        <h2 className="text-3xl font-extrabold mb-6 text-red-600 drop-shadow-lg text-center">Popular Movies</h2>
        <Carrusel>
          {popularMovies.map((movie) => (
            <Link
              key={movie.id}
              href={`/movie/${movie.id}`}
              className="min-w-[200px] flex-shrink-0 hover:scale-105 transition-transform duration-200"
            >
              <Image
                src={`https://image.tmdb.org/t/p/w500${movie.poster_path}`}
                alt={movie.title}
                width={200}
                height={300}
                className="rounded-lg shadow-lg"
              />
              <p className="text-center mt-2">{movie.title}</p>
            </Link>
          ))}
        </Carrusel>
      </section>

      <section className="w-full max-w-6xl mb-12">
        <h2 className="text-3xl font-extrabold mb-6 text-red-600 drop-shadow-lg text-center">Now Playing</h2>
        <Carrusel>
          {nowPlayingMovies.map((movie) => (
            <Link
              key={movie.id}
              href={`/movie/${movie.id}`}
              className="min-w-[200px] flex-shrink-0 hover:scale-105 transition-transform duration-200"
            >
              <Image
                src={`https://image.tmdb.org/t/p/w500${movie.poster_path}`}
                alt={movie.title}
                width={200}
                height={300}
                className="rounded-lg shadow-lg"
              />
              <p className="text-center mt-2">{movie.title}</p>
            </Link>
          ))}
        </Carrusel>
      </section>
    </main>
  );
}
