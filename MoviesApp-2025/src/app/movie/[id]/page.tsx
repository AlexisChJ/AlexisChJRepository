"use client";
import { useEffect, useState } from "react";
import Image from "next/image";
import { getMovieById } from "@/services/movies/getMovieById";
import { markAsFavorite } from "@/services/accounts/markAsFavorite";
import { useGuestSession } from "@/providers/GuestSessionContext";
import { useParams } from "next/navigation";
import { IMovieDetail } from "@/types/MovieDetails";
import Carrusel from "@/components/Carrusel/Carrusel";
import { getRecommendedMovies } from "@/services/movies/getRecommendedMovies";
const FAVORITES_STORAGE_KEY = "favoriteMovieIds";
import Link from "next/link";

const MovieDetailPage = () => {
  const { id } = useParams();
  const [movie, setMovie] = useState<IMovieDetail>();
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);
  const [isFavorite, setIsFavorite] = useState(false);
  const [updatingFavorite, setUpdatingFavorite] = useState(false);
  const { guestSessionId } = useGuestSession();

  useEffect(() => {
    if (!id || typeof id !== "string") return;

    const fetchMovie = async () => {
      setLoading(true);
      setError(null);
      try {
        const data = await getMovieById(id);
        setMovie(data);
      } catch (err) {
        console.error("Error fetching movie", err);
        setError("Could not load movie.");
      } finally {
        setLoading(false);
      }
    };
    fetchMovie();
  }, [id]);

  useEffect(() => {
    if (!id || typeof id !== "string") return;
    try {
      const storedFavorites = localStorage.getItem(FAVORITES_STORAGE_KEY);
      const favoriteIds = storedFavorites ? JSON.parse(storedFavorites) : [];
      setIsFavorite(favoriteIds.includes(Number(id)));
    } catch {
      localStorage.removeItem(FAVORITES_STORAGE_KEY);
      setIsFavorite(false);
    }
  }, [id]);

  const handleToggleFavorite = async () => {
    if (!movie) return;
    
    const updateLocalStorage = (newFavoriteState: boolean) => {
      try {
        const storedFavorites = localStorage.getItem(FAVORITES_STORAGE_KEY);
        const favoriteIds = storedFavorites ? JSON.parse(storedFavorites) : [];

        const updatedFavorites = newFavoriteState
          ? [...new Set([...favoriteIds, movie.id])]
          : favoriteIds.filter((favId: number) => favId !== movie.id);

        localStorage.setItem(FAVORITES_STORAGE_KEY, JSON.stringify(updatedFavorites));
      } catch (error) {
        console.error("Error updating localStorage:", error);
        if (newFavoriteState) {
          localStorage.setItem(FAVORITES_STORAGE_KEY, JSON.stringify([movie.id]));
        }
      }
    };

    setUpdatingFavorite(true);
    const newFavoriteState = !isFavorite;
    
    try {
      if (guestSessionId) {
        await markAsFavorite(movie.id, newFavoriteState, guestSessionId);
      } else {
        console.log("No guest session ID available. Updating only in local storage.");
      }
      
      setIsFavorite(newFavoriteState);
      updateLocalStorage(newFavoriteState);
      
    } catch (error) {
      console.error("Failed to update favorite:", error);
      alert("Failed to update favorite. Please try again.");
    } finally {
      setUpdatingFavorite(false);
    }
  };

  interface IRecommendedMovie {
    id: number;
    title: string;
    poster_path: string | null;
  }
  const [recommended, setRecommended] = useState<IRecommendedMovie[]>([]);


  useEffect(() => {
    if (!id || typeof id !== "string") return;

    const fetchRecommended = async () => {
      try {
        const data = await getRecommendedMovies(id);
        setRecommended(data.results || []);
      } catch (error) {
        console.error("Error fetching recommended movies:", error);
      }
    };

    fetchRecommended();
  }, [id]);

  if (loading) return <div>Loading movie...</div>;
  if (error) return <div>{error}</div>;
  if (!movie) return <div>No movie found.</div>;

  return (
    <div className="bg-black text-white min-h-screen">
      <div className="max-w-4xl mx-auto p-4">
        <div className="flex flex-col sm:flex-row gap-6">
          {movie.poster_path ? (
            <Image
              src={`https://image.tmdb.org/t/p/w500${movie.poster_path}`}
              alt={movie.title}
              className="rounded-xl w-full sm:w-64"
              width={450}
              height={450}
            />
          ) : (
            <div className="bg-gray-800 rounded-xl w-full sm:w-64 h-96 flex items-center justify-center">
              No image available
            </div>
          )}
          <div className="flex flex-col space-y-4">
            <h1 className="text-3xl font-bold">
              {movie.title}{" "}
              <span className="text-gray-400 font-normal">
                ({movie.release_date ? new Date(movie.release_date).getFullYear() : "N/A"})
              </span>
            </h1>
            {movie.tagline && <p className="italic text-blue-400">{movie.tagline}</p>}
            <p>{movie.overview}</p>
            <div>
              <strong>Genres:</strong> {movie.genres.map((g) => g.name).join(", ")}
            </div>
            <div>
              <strong>Rating:</strong> {movie.vote_average.toFixed(1)}
            </div>
            <div className="flex flex-col gap-2">
              <button
                onClick={handleToggleFavorite}
                disabled={updatingFavorite}
                className={`px-4 py-2 rounded ${
                  isFavorite
                    ? "bg-red-500 hover:bg-red-600"
                    : "bg-yellow-500 hover:bg-yellow-600"
                } text-white font-bold w-max`}
              >
                {updatingFavorite
                  ? "Updating..."
                  : isFavorite
                  ? "Remove from Favorites"
                  : "Add to Favorites"}
              </button>
            </div>
          </div>
        </div>
      </div>
      {recommended.length > 0 && (
        <div className="max-w-6xl mx-auto mt-16 px-4">
          <h2 className="text-3xl font-bold mb-4 text-white">Recommended Movies</h2>
          <Carrusel>
            {recommended.map((movie) => (
              <Link
                key={movie.id}
                href={`/movie/${movie.id}`}
                className="min-w-[200px] flex-shrink-0 hover:scale-105 transition-transform duration-200"
              >
                {movie.poster_path ? (
                  <Image
                    src={`https://image.tmdb.org/t/p/w500${movie.poster_path}`}
                    alt={movie.title}
                    width={200}
                    height={300}
                    className="rounded-lg shadow-lg"
                  />
                ) : (
                  <div className="bg-gray-800 w-[200px] h-[300px] flex items-center justify-center text-gray-500 rounded-lg shadow-lg">
                    No image
                  </div>
                )}
                <p className="text-center mt-2 text-white">{movie.title}</p>
              </Link>
            ))}
          </Carrusel>
        </div>
      )}
    </div>
  );
};

export default MovieDetailPage;