"use client";

import React, { useEffect, useState } from "react";
import { getTopRatedMovies } from "@/services/movies/getTopRated";
import { IMovieDetail } from "@/types/MovieDetails";
import MovieList from "@/components/MovieList/MovieList";

const TopRatedPage = () => {
  const [loading, setLoading] = useState(false);
  const [movies, setMovies] = useState<IMovieDetail[]>([]);
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);

  useEffect(() => {
    const fetchTopRatedMovies = async () => {
      setLoading(true);
      try {
        const data = await getTopRatedMovies(currentPage);
        setMovies(data.results);
        setTotalPages(data.total_pages);
      } catch (err) {
        console.error("Error loading movies: ", err);
      }
      setLoading(false);
    };

    fetchTopRatedMovies();
  }, [currentPage]);

  const handlePrevPage = () => {
    setCurrentPage((prev) => Math.max(prev - 1, 1));
  };

  const handleNextPage = () => {
    setCurrentPage((prev) => Math.min(prev + 1, totalPages));
  };

  return (
    <div className="bg-black min-h-screen px-4 py-8 text-black">
      <div className="max-w-6xl mx-auto">
        <h1 className="text-4xl sm:text-5xl font-extrabold mb-8 text-center text-red-500 tracking-wide">
          Top Rated
        </h1>

        {loading ? (
          <div className="flex justify-center items-center h-64">
            <div className="animate-spin rounded-full h-12 w-12 border-t-4 border-red-500 border-opacity-50"></div>
          </div>
        ) : (
          <>
            <MovieList text="" loading={loading} movies={movies} />

            {/* Paginación simple */}
            <div className="flex justify-center space-x-4 mt-6">
              <button
                onClick={handlePrevPage}
                disabled={currentPage === 1}
                className={`px-4 py-2 rounded ${
                  currentPage === 1
                    ? "bg-gray-500 cursor-not-allowed"
                    : "bg-red-500 hover:bg-red-600"
                } text-white font-semibold`}
              >
                Anterior
              </button>
              <span className="text-white flex items-center">
                Página {currentPage} de {totalPages}
              </span>
              <button
                onClick={handleNextPage}
                disabled={currentPage === totalPages}
                className={`px-4 py-2 rounded ${
                  currentPage === totalPages
                    ? "bg-gray-500 cursor-not-allowed"
                    : "bg-red-500 hover:bg-red-600"
                } text-white font-semibold`}
              >
                Siguiente
              </button>
            </div>
          </>
        )}
      </div>
    </div>
  );
};

export default TopRatedPage;
