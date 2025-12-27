import api from "../api";

export const getRecommendedMovies = async (id: string) => {
    try {
        const { data } = await api.get(`/movie/${id}/recommendations`, {
            params: {
                language: 'en-US',
                page: 1
            }
        });
        return data;
    } catch (error) {
        throw error;
    }
};
