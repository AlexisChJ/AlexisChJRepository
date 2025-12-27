import React, { useRef } from "react";
import { ChevronLeft, ChevronRight } from "lucide-react";

interface CarruselProps {
  children: React.ReactNode;
}

const Carrusel: React.FC<CarruselProps> = ({ children }) => {
  const CarruselRef = useRef<HTMLDivElement>(null);

  const scroll = (direction: "left" | "right") => {
    if (!CarruselRef.current) return;

    const { scrollLeft, clientWidth } = CarruselRef.current;
    const scrollTo = direction === "left" 
      ? scrollLeft - clientWidth 
      : scrollLeft + clientWidth;

    CarruselRef.current.scrollTo({ left: scrollTo, behavior: "smooth" });
  };

  return (
    <div className="relative w-full">
      <button
        onClick={() => scroll("left")}
        className="absolute left-0 top-1/2 z-10 -translate-y-1/2 bg-gray-500 shadow-md rounded-full p-2"
      >
        <ChevronLeft />
      </button>

      <div
        ref={CarruselRef}
        className="flex overflow-x-auto scroll-smooth space-x-4 px-12 py-4 scrollbar-hide"
      >
        {children}
      </div>

      <button
        onClick={() => scroll("right")}
        className="absolute right-0 top-1/2 z-10 -translate-y-1/2 bg-gray-500  shadow-md rounded-full p-2"
      >
        <ChevronRight />
      </button>
    </div>
  );
};

export default Carrusel;
