import Config from "@/config";
import Image from "next/image";


interface IMovieCard {
  title: string;
  voteAverage: number;
  posterPath: string;
  releaseYear: number;
  description: string;
}

const MovieCard: React.FC<IMovieCard> = ({
  title,
  voteAverage,
  posterPath,
  releaseYear,
  description,
}) => {
  const poster = Config.IMAGE_SOURCE + posterPath;

  return (
    <div className="flex items-center justify-center">
      <div className="mx-auto bg-gray-400 rounded-2xl shadow-lg overflow-hidden flex flex-col h-full w-full max-w-[480px]">
        <div className="rounded-2xl bg-slate-200 overflow-hidden w-full">
          <div className="relative w-full h-[300px]">
            <Image
              src={poster}
              fill
              className="rounded-t-2xl object-cover"
              alt={title}
              sizes="(max-width: 768px) 100vw, 480px"
            />
          </div>

          <div className="p-5 z-10 font-poppins">
            <p className="h-10 font-bold text-lg">{title}</p>
            <p className="text-slate-600 pt-2 font-semibold">
              ({releaseYear})
            </p>

            <div className="h-20">
              <span className="line-clamp-3 py-2 h-20 text-sm font-light leading-relaxed font-poppins">
                {description}
              </span>
            </div>

            <div className="grid-cols-2 flex justify-between">
              <div className="font-black flex flex-col">
                <span className="text-orange-400 text-lg">SCORE</span>
                <span className="text-3xl flex gap-x-1 items-center group-hover:text-yellow-600">
                  {voteAverage.toFixed(1)}
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    fill="currentColor"
                    viewBox="0 0 24 24"
                    className="w-6 h-6 text-yellow-800"
                  >
                    <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z" />
                  </svg>
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default MovieCard;
