"use client";
import React, { useEffect, useState } from "react";
import { useGuestSession } from "@/providers/GuestSessionContext";
import { getFavoriteMovies } from "@/services/accounts/getFavoriteMovies";
import { getMovieById } from "@/services/movies/getMovieById";
import MovieList from "@/components/MovieList/MovieList";
import { IMovieDetail } from "@/types/MovieDetails";

const FAVORITES_STORAGE_KEY = "favoriteMovieIds";

const MyFavoritesPage = () => {

  const { guestSessionId } = useGuestSession();
  const [loading, setLoading] = useState<boolean>(false);
  const [movies, setMovies] = useState<IMovieDetail[]>([]);
  const [isOfflineMode, setIsOfflineMode] = useState<boolean>(false);

  useEffect(() => {
    const fetchFavorites = async () => {
      setLoading(true);
      
      try {
        
        if (guestSessionId) {
          const data = await getFavoriteMovies(guestSessionId);
          setMovies(data?.results || []);
          setIsOfflineMode(false);
        } 

        else {
          await fetchLocalFavorites();
          setIsOfflineMode(true);
        }
      } catch (err) {
        console.error("Error loading favorite movies:", err);

        if (guestSessionId) {
          await fetchLocalFavorites();
          setIsOfflineMode(true);
        }
      } finally {
        setLoading(false);
      }
    };

    fetchFavorites();
  }, [guestSessionId]);


  const fetchLocalFavorites = async () => {
    try {
      
      const storedFavorites = localStorage.getItem(FAVORITES_STORAGE_KEY);
      const favoriteIds: number[] = storedFavorites ? JSON.parse(storedFavorites) : [];
      
      if (favoriteIds.length === 0) {
        setMovies([]);
        return;
      }

      
      const moviePromises = favoriteIds.map(async (id) => {
        try {
          return await getMovieById(id.toString());
        } catch (error) {
          console.error(`Error fetching movie with ID ${id}:`, error);
          return null;
        }
      });
      const moviesData = await Promise.all(moviePromises);
      const validMovies = moviesData.filter(movie => movie !== null).map(movie => ({
        ...movie,
        poster_path: movie.poster_path,
        title: movie.title,
        vote_average: movie.vote_average,
        id: movie.id
      }));

      setMovies(validMovies);
    } catch (error) {
      console.error("Error loading favorites from localStorage:", error);
      setMovies([]);
    }
  };

  return (
    <div className="bg-black min-h-screen px-6 py-10 text-black flex flex-col items-center">
      <h1 className="text-4xl sm:text-5xl font-extrabold mb-8 text-center text-red-500 tracking-wide">
        My Favorite Movies
      </h1>
    
      {loading && (
        <div className="flex justify-center items-center h-32">
          <div className="animate-spin rounded-full h-12 w-12 border-t-4 border-red-600 border-opacity-50"></div>
          <span className="ml-4 text-lg text-gray-400">Loading favorites...</span>
        </div>
      )}

      {!loading && movies.length === 0 && (
        <div className="text-center mt-20 max-w-md text-gray-400">
          <p className="text-2xl font-semibold mb-3">No favorite movies yet.</p>
          <p className="text-base italic text-gray-500">
            Browse movies and add them to your favorites to see them here.
          </p>
        </div>
      )}

      {!loading && movies.length > 0 && (
        <div className="w-full max-w-6xl">
          <MovieList movies={movies} text="" loading={loading} />
        </div>
      )}
      {isOfflineMode && (
        <div className="text-yellow-400 text-sm mt-4">
          Navigate throw the pages to select movies and add them to your favorites.
        </div>
      )}
    </div>
  );
};

export default MyFavoritesPage;