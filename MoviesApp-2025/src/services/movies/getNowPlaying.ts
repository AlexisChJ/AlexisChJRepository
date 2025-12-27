import api from "../api";

export const getNowPlayingMovies = async (page: number = 1) => {
// eslint-disable-next-line  @typescript-eslint/no-explicit-any
  let res: any;
  const endpoint = `/movie/now_playing?language=en-US&page=${page}`;

  try {
    const response = await api.get(endpoint);
    res = response.data;
// eslint-disable-next-line  @typescript-eslint/no-explicit-any
  } catch (err: any) {
    res = err.response;
  }

  return res;
};
